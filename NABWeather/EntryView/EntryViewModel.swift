//
//  EntryViewModel.swift
//  NABWeather
//
//  Created by hungnguy on 4/2/22.
//

import Foundation
import RxCocoa

protocol EntryViewModelProtocol {
    var weatherItems : BehaviorRelay<[WeatherItem]> { get set }
    var currentCityString: BehaviorRelay<String> { get set }
    
    func getWeatherList(count: Int, city: String, failure: ((RequestError)->Void)?)
}

class EntryViewModel: EntryViewModelProtocol {
    
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
    }
}

