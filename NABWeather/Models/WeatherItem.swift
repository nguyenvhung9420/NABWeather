//
//  WeatherItem.swift
//  NABWeather
//
//  Created by hungnguy on 4/2/22.
//

import Foundation
import ObjectMapper

class WeatherItem: Mappable {
    var dt: Int?
    var dateInterval: Int?
    var avgTemp: Temperature?
    var pressure: Int = 1
    var humid: Double = 0.0
    var description: String?
    var icon: String = ""
    
    init() {}
    
    convenience init(id: Int) {
        self.init()
        self.dt = id
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        dt <- map["dt"]
        description <- map["weather.0.description"]
        icon <- map["weather.0.icon"]
        avgTemp <- map["temp"]
        pressure <- map["pressure"]
        humid <- map["humidity"]
        dateInterval <- map["dt"]
    }
    
    var id: String {
        guard let dt = self.dt else {
            return ""
        }
        return String(describing: dt)
    }
    
    var date: Date {
        let date = Date(timeIntervalSince1970: Double(self.dateInterval ?? 0))
        return date
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        return formatter.string(from: self.date)
    }
    
    var weekday: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self.date)
    }
    
    var fullDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMM, yyyy"
        return formatter.string(from: self.date)
    }
    
    var averageTempString: String {
        let unit = UserDefaults.standard.string(forKey: "metric")
        let formatString = "%.0f°\(unit == "metric" ? "C" : "F")"
        return String(format: formatString, self.avgTemp?.day ?? 0.0)
    }
}

extension WeatherItem: Equatable {
    static func == (lhs: WeatherItem, rhs: WeatherItem) -> Bool {
        return lhs.dt == rhs.dt
    } 
}

class Temperature: Mappable {
    var day: Double?
    var min: Double?
    var max: Double?
    var night: Double?
    var morning: Double?
    
    init() {}
    
    required init?(map: Map) {}

    // Mappable
    func mapping(map: Map) {
        day <- map["day"]
        min <- map["min"]
        max <- map["max"]
        night <- map["night"]
        morning <- map["morn"]
    }
}
