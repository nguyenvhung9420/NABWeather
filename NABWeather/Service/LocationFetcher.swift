//
//  LocationFetcher.swift
//  WeatherWithNAB
//
//  Created by Hung Nguyen on 9/2/21.
//

import Foundation
import CoreLocation


class LocationFetcher: NSObject, CLLocationManagerDelegate {
    static let shared = LocationFetcher()
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    var onAccept: (()->Void)?

    override init() {
        super.init()
        manager.delegate = self
    }

    func start(_ onAccept: @escaping ()->Void) {
        print("It comes here manager.requestWhenInUseAuthorization()")
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        self.onAccept = onAccept
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status ==  .authorizedAlways {
            if self.onAccept != nil {
                self.onAccept!()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}

