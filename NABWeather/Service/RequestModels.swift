//
//  RequestModels.swift
//  NABWeather
//
//  Created by hungnguy on 4/2/22.
//

import Foundation

class RequestError: Error {
    var message: String = "Unknown error"
    var code: String = ""
    var error: NSError?
    
    init(code: String, message: String, error: NSError?) {
        self.code = code
        self.message = message
        if let _ = error {
            self.error = error
        }
    }
}

class RequestURL {
    var requestType: RequestURLEnum?
    
    init(type: RequestURLEnum) {
        self.requestType = type
    }
    
    enum RequestURLEnum: String {
        case baseWeatherUrl = "https://api.openweathermap.org/data/2.5/forecast/daily?%@appid=%@&units=%@"
        case weatherByCity = "https://api.openweathermap.org/data/2.5/forecast/daily?q=%@&cnt=7&appid=%@&units=%@"
        case weatherIcon = "https://openweathermap.org/img/wn/%@@2x.png"
        case weatherByLatLong = "https://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&cnt=7&appid=%@&units=%@"
    }
    
    func getURL(params: [String] = [], metricType: String = "metric")  -> URL? {
        let apiKey = Constant.openWeatherApiKey
        if params.count >= 1 {
            switch self.requestType {
            case .weatherByCity, .weatherIcon:
                let str = String(format: self.requestType?.rawValue ?? "", params[0], apiKey, metricType)
                return URL(string: str)
            case .weatherByLatLong:
                if !(params.count >= 2) {
                    return nil
                }
                let lat = params[0]
                let long = params[1]
                let str = String(format: self.requestType?.rawValue ?? "", lat, long, apiKey, metricType) 
                return URL(string: str)
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
