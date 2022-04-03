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

enum MetricType: String  {
    case metric = "metric"
    case imperial = "imperial"
}

class RequestURL {
    var requestType: RequestURLEnum?
    
    init(type: RequestURLEnum) {
        self.requestType = type
    }
    
    enum RequestURLEnum: String {
        case baseWeatherUrl = "https://api.openweathermap.org/data/2.5/forecast/daily?%@appid=%@&units=metric"
        case weatherByCity = "https://api.openweathermap.org/data/2.5/forecast/daily?q=%@&cnt=7&appid=%@&units=metric"
        case weatherIcon = "https://openweathermap.org/img/wn/%@@2x.png"
        case weatherByLatLong = "https://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&cnt=7&appid=%@&units=metric"
    }
    
    func getURL(params: [String] = [], metricType: MetricType = .metric)  -> URL? {
        let apiKey = Constant.openWeatherApiKey
        if params.count >= 1 {
            switch self.requestType {
            case .weatherByCity, .weatherIcon:
                let str = String(format: self.requestType?.rawValue ?? "", params[0], apiKey)
                print(str)
                return URL(string: str)
            case .weatherByLatLong:
                if !(params.count >= 2) {
                    return nil
                }
                let lat = params[0]
                let long = params[1]
                let str = String(format: self.requestType?.rawValue ?? "", lat, long, apiKey)
                print(str)
                return URL(string: str)
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
