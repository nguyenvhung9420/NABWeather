//
//  WeatherService.swift
//  WeatherWithNAB
//
//  Created by Hung Nguyen on 8/30/21.
//

import Foundation
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

protocol WeatherServiceProtocol {
    typealias ApiCompletion<T> = (T, String)->Void
    
    var api: Network { get set }
    func getWeatherList(byCity city: String, completion: @escaping ApiCompletion<[WeatherItem]>, failure: @escaping (RequestError)->Void)
}

class WeatherService: WeatherServiceProtocol {
    var api = Network()
    
    func getWeatherList(byCity city: String, completion: @escaping ApiCompletion<[WeatherItem]>, failure: @escaping (RequestError)->Void) {
        var url: URL?
        var currentLocation: CLLocation?
        let metric = UserDefaults.standard.string(forKey: Constant.metricKey) ?? "metric"
        
        guard let cityUrl = RequestURL(type: .weatherByCity).getURL(params: [city], metricType: metric) else {
            failure(RequestError(code: "", message: "Unable to get weather of this city.", error: nil))
            return
        }
        url = cityUrl
        
        guard let finalUrl = url else {
            failure(RequestError(code: "", message: "Unable to get weather due to some problems.", error: nil))
            return
        }
        api.get(url: finalUrl, completion: { json in
            let array: [WeatherItem] = json["list"].arrayValue.map { eachJSON in
                let piece: WeatherItem = WeatherItem(JSONString: eachJSON.description) ?? WeatherItem()
                return piece
            }
            completion(array, (city != "" ? city : ""))
        }, failure: { error in
            failure(error)
        })
    }
    
}
