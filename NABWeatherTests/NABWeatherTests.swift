//
//  NABWeatherTests.swift
//  NABWeatherTests
//
//  Created by hungnguy on 4/2/22.
//

import XCTest
import RxSwift
import RxTest
import RxCocoa
import RxBlocking

@testable import NABWeather

class NABWeatherTests: XCTestCase {
    
    private let keywordWhenSuccess: String = "Saigon"
    private let keywordWhenSuccessLower: String = "saigon"
    private let keywordWhenFailed: String = "saigo"
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    func testViewModel() {
        let viewModel = ViewModelMock()
        let itemsTest = scheduler.createObserver([WeatherItem].self)
        
        viewModel.getWeatherList(count: 10, city: keywordWhenSuccessLower, failure: nil)
        
        viewModel.weatherItems
            .bind(to: itemsTest)
            .disposed(by: disposeBag)
         
        scheduler.createColdObservable([.next(10, [WeatherItem(id: 10)]),
                                        .next(20, [WeatherItem(id: 10)]),
                                        .next(30, [WeatherItem(id: 10)])])
        .bind(to: viewModel.weatherItems)
        .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(itemsTest.events, [
            .next(0, []),
            .next(10, [WeatherItem(id: 10)]),
            .next(20, [WeatherItem(id: 10)]),
            .next(30, [WeatherItem(id: 10)])
        ])
    }
     
    func testSuccessCase() {
        let appServerClient = WeatherServiceMock()
     
        let viewModel = EntryViewModel()
        viewModel.getWeatherList(count: 10, city: keywordWhenSuccessLower, failure: nil)
     
        let expectDataFetched = expectation(description: "Data is fetched with success")
        viewModel.weatherItems.subscribe(
            onNext:  { items in
                var isOK: Bool = false
                if items.isEmpty == false {
                    isOK = true
                }
                XCTAssertTrue(isOK)
                expectDataFetched.fulfill()
                
            }
        ).disposed(by: disposeBag)
     
        wait(for: [expectDataFetched], timeout:0.1)
    }
    
    func testFailureCase() {
        let disposeBag = DisposeBag()
        let appServerClient = WeatherServiceMock()
        
        let viewModel = EntryViewModel()
        viewModel.getWeatherList(count: 10, city: self.keywordWhenFailed, failure: nil)
        
        let expectDataNotFetched = expectation(description: "Data is fetched with FAILURE")
        viewModel.weatherItems.subscribe(
            onNext:  { items in
                var isOK: Bool = false
                isOK = items.isEmpty
                XCTAssertTrue(isOK)
                expectDataNotFetched.fulfill()
                
            }
        ).disposed(by: disposeBag)
        wait(for: [expectDataNotFetched], timeout:0.1)
    }
    
    class WeatherServiceMock: WeatherServiceProtocol {
        var invokedApiSetter = false
        var invokedApiSetterCount = 0
        var invokedApi: Network?
        var invokedApiList = [Network]()
        var invokedApiGetter = false
        var invokedApiGetterCount = 0
        var stubbedApi: Network!

        var api: Network {
            set {
                invokedApiSetter = true
                invokedApiSetterCount += 1
                invokedApi = newValue
                invokedApiList.append(newValue)
            }
            get {
                invokedApiGetter = true
                invokedApiGetterCount += 1
                return stubbedApi
            }
        }

        var invokedGetWeatherList = false
        var invokedGetWeatherListCount = 0
        var invokedGetWeatherListParameters: (city: String, completion: ApiCompletion<[WeatherItem]>)?
        var invokedGetWeatherListParametersList = [(city: String, completion: ApiCompletion<[WeatherItem]>)]()
        var stubbedGetWeatherListFailureResult: (RequestError, Void)?

        func getWeatherList(byCity city: String, completion: @escaping ApiCompletion<[WeatherItem]>, failure: @escaping (RequestError)->Void) {
            invokedGetWeatherList = true
            invokedGetWeatherListCount += 1
            invokedGetWeatherListParameters = (city, completion)
            invokedGetWeatherListParametersList.append((city, completion))
            if let result = stubbedGetWeatherListFailureResult {
                failure(result.0)
            }
        }
    }
    
    class ViewModelMock: EntryViewModelProtocol {
        var invokedWeatherItemsSetter = false
        var invokedWeatherItemsSetterCount = 0
        var invokedWeatherItems: BehaviorRelay<[WeatherItem]>?
        var invokedWeatherItemsList = [BehaviorRelay<[WeatherItem]>]()
        var invokedWeatherItemsGetter = false
        var invokedWeatherItemsGetterCount = 0
        var stubbedWeatherItems: BehaviorRelay<[WeatherItem]> = BehaviorRelay<[WeatherItem]>(value: [])

        var weatherItems: BehaviorRelay<[WeatherItem]> {
            set {
                invokedWeatherItemsSetter = true
                invokedWeatherItemsSetterCount += 1
                invokedWeatherItems = newValue
                invokedWeatherItemsList.append(newValue)
            }
            get {
                invokedWeatherItemsGetter = true
                invokedWeatherItemsGetterCount += 1
                return stubbedWeatherItems
            }
        }

        var invokedCurrentCityStringSetter = false
        var invokedCurrentCityStringSetterCount = 0
        var invokedCurrentCityString: BehaviorRelay<String>?
        var invokedCurrentCityStringList = [BehaviorRelay<String>]()
        var invokedCurrentCityStringGetter = false
        var invokedCurrentCityStringGetterCount = 0
        var stubbedCurrentCityString: BehaviorRelay<String>!

        var currentCityString: BehaviorRelay<String> {
            set {
                invokedCurrentCityStringSetter = true
                invokedCurrentCityStringSetterCount += 1
                invokedCurrentCityString = newValue
                invokedCurrentCityStringList.append(newValue)
            }
            get {
                invokedCurrentCityStringGetter = true
                invokedCurrentCityStringGetterCount += 1
                return stubbedCurrentCityString
            }
        }

        var invokedGetWeatherList = false
        var invokedGetWeatherListCount = 0
        var invokedGetWeatherListParameters: (count: Int, city: String)?
        var invokedGetWeatherListParametersList = [(count: Int, city: String)]()
        var stubbedGetWeatherListFailureResult: (RequestError, Void)?

        func getWeatherList(count: Int = 10, city: String = "", failure: ((RequestError)->Void)?) {
            invokedGetWeatherList = true
            invokedGetWeatherListCount += 1
            invokedGetWeatherListParameters = (count, city)
            invokedGetWeatherListParametersList.append((count, city))
            if let result = stubbedGetWeatherListFailureResult {
                failure?(result.0)
            }
        }
    }

}
