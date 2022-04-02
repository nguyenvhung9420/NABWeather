//
//  EntryViewModel.swift
//  NABWeather
//
//  Created by hungnguy on 4/2/22.
//

import Foundation
import RxCocoa

class EntryViewModel {
    
    var weatherItems : BehaviorRelay<[WeatherItem]> = BehaviorRelay(value: [])
    var currentCityString: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    private var weatherService = WeatherService()


    func getWeatherList(count: Int = 10, city: String = "", failure: ((RequestError)->Void)?) {
        
        
        weatherService.getWeatherList(byCity: city, completion: { items, cityNameByCLLocation  in
            if failure != nil {
                failure!(RequestError(code: "", message: "", error: nil))
            }
            self.weatherItems.accept(items)
            self.currentCityString.accept( cityNameByCLLocation != "" ? cityNameByCLLocation : city)
        }, failure: { error in
            if failure != nil {
                failure!(error)
            }
        })
        
//        insightService.listInsight(filter: [],
//                                   startKey: insightResponse.lastKey, page: insightResponse.page, limit: limit, sort: sortType, sortBy: sortByParams) { [weak self] result in
//            guard let self = self else { return }
//            self.didFirstLoad = true
//            HudManager.shared.dismiss()
//            switch result {
//            case .success(let response):
//                self.insightResponse = response
//                var insightList = self.insightList.value
//                if isResetFilter {
//                    insightList = [.all : [], .popular : []]
//                }
//                if isRefresh {
//                    insightList = [.all : [], .popular : []]
//                }
//
//                insightList[self.selectedTabTypeData.value]?.append(contentsOf: response.items)
//                self.insightList.accept(insightList)
//                for each in insightList[.all] ?? [] {
//                    USLog.debug("Retrieved insight \(each.name), id: \(each.id)")
//                }
//                PastInsightList.save(tab: self.selectedTabTypeData.value, products: insightList[self.selectedTabTypeData.value] ?? [])
//                ProductAndInsightStaticObservable.insightList.accept(self.insightList.value[.all] ?? [])
//            case .failure(let error):
//
//                let usError = USError.convertToUSError(error: error)
//
//                switch usError.code {
//                case USError.Code.noInternetConnection.rawValue:
//                    let count = self.insightList.value[self.selectedTabTypeData.value]?.count ?? 0
//                    if count == 0 {
//                        self.insightList.accept( [.all : [], .popular : []])
//                        HudManager.shared.showNetworkErrorIfNeeded()
//                    }
//                default:
//                    break
//
//                }
//                break
//            }
//        }
    }
}

