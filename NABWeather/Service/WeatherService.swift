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

class WeatherService {
    var api = Network()
    typealias ApiCompletion<T> = (T, String)->Void
    
    public func getWeatherList(byCity city: String, completion: @escaping ApiCompletion<[WeatherItem]>, failure: @escaping (RequestError)->Void) {
        var url: URL?
        var currentLocation: CLLocation?
        if city != "" {
            guard let cityUrl = RequestURL(type: .weatherByCity).getURL(params: [city]) else {
                print("Failed to get url with city: \(city)")
                failure(RequestError(code: "", message: "Unable to get weather of this city.", error: nil))
                return
            }
            url = cityUrl
        } else {
            let locManager = CLLocationManager()
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways {
                currentLocation = locManager.location
            }
            if let lat = currentLocation?.coordinate.latitude, let long = currentLocation?.coordinate.longitude {
                guard let locationBasedUrl = RequestURL(type: .weatherByLatLong).getURL(params: ["\(lat)", "\(long)"]) else {
                    print("Failed to get url with let long: \([lat.string, long.string])")
                    failure(RequestError(code: "", message: "Unable to get weather of this city and/or this location.", error: nil))
                    return
                }
                url = locationBasedUrl
            }
        }
        guard let finalUrl = url else {
            failure(RequestError(code: "", message: "Unable to get weather due to some problems.", error: nil))
            return
        }
        api.get(url: finalUrl, completion: { json in
            let array: [WeatherItem] = json["list"].arrayValue.map { eachJSON in
                let piece: WeatherItem = WeatherItem(JSONString: eachJSON.description) ?? WeatherItem()
                return piece
            }
            print(array.map { return $0.description })
            if let _  = currentLocation {
                currentLocation!.placemark { placemark, error in
                    if let placemark = placemark {
                        print(placemark.city ?? "")
                        completion(array, placemark.city ?? (city != "" ? city : ""))
                    } else {
                        completion(array, (city != "" ? city : ""))
                    }
                    if error != nil {
                        completion(array, (city != "" ? city : ""))
                        return
                    }
                }
            } else {
                completion(array, (city != "" ? city : ""))
            }
        }, failure: { error in
            failure(error)
        })
    }
    
}
