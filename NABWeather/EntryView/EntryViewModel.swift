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
    }
}

