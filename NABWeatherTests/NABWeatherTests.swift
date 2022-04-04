//
//  NABWeatherTests.swift
//  NABWeatherTests
//
//  Created by hungnguy on 4/2/22.
//

import XCTest
import RxSwift

@testable import NABWeather

class NABWeatherTests: XCTestCase {
    
    private let keywordWhenSuccess: String = "Saigon"
    private let keywordWhenSuccessLower: String = "saigon"
    
    private let keywordWhenFailed: String = "saigo"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
     
    func testSuccessCase() {
        let disposeBag = DisposeBag()
        let appServerClient = WeatherService()
     
        let viewModel = EntryViewModel()
        viewModel.getWeatherList(count: 10, city: self.keywordWhenSuccessLower, failure: nil)
     
        let expectNormalFriendCellCreated = expectation(description: "Data is fetched with success")
        viewModel.weatherItems.subscribe(
            onNext:  { items in
                var firstCellIsNormal: Bool = false
                
                print("items = \(items)")
                if items.isEmpty == false {
                    firstCellIsNormal = true
                }
                
                XCTAssertTrue(firstCellIsNormal)
                expectNormalFriendCellCreated.fulfill()
                
            }
        ).disposed(by: disposeBag)
     
        wait(for: [expectNormalFriendCellCreated], timeout:0.1)
    }
    
    func testFailureCase() {
        let disposeBag = DisposeBag()
        let appServerClient = WeatherService()
        
        let viewModel = EntryViewModel()
        viewModel.getWeatherList(count: 10, city: self.keywordWhenFailed, failure: nil)
        
        let expectNormalFriendCellCreated = expectation(description: "Data is fetched with FAILURE")
        viewModel.weatherItems.subscribe(
            onNext:  { items in
                var firstCellIsNormal: Bool = false
                firstCellIsNormal = items.isEmpty
                XCTAssertTrue(firstCellIsNormal)
                expectNormalFriendCellCreated.fulfill()
                
            }
        ).disposed(by: disposeBag)
        wait(for: [expectNormalFriendCellCreated], timeout:0.1)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }


}
