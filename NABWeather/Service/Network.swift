//
//  Network.swift
//  WeatherWithNAB
//
//  Created by Hung Nguyen on 8/30/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class Network {
    
    typealias NetworkCompletion<T> = (T)->Void
    typealias NetworkFailure = (RequestError)->Void
    
     func get(url: URL, completion: @escaping NetworkCompletion<JSON>, failure: @escaping NetworkFailure) {
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        AF.request(req).responseJSON(completionHandler: { response in
            print("response = \(response)")
            if let error = response.error as NSError? {
                failure(RequestError(code: "", message: "Cannot get weather.", error: error))
            }
            if let data =  response.data, let json = try? JSON(data: data) {
                let message = json["message"].stringValue
                let code = json["cod"].stringValue
                if code != "200" {
                    failure(RequestError(code: "\(code)", message: message, error: nil))
                } else {
                    completion(json)
                }
            }
        })
    }

     func post(url: URL, completion: @escaping NetworkCompletion<JSON>, failure: @escaping NetworkFailure) {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        AF.request(req).responseJSON(completionHandler: { response in
            if let error = response.error as NSError? {
                failure(RequestError(code: "", message: "", error: error))
            }
            if let data =  response.data, let json = try? JSON(data: data) {
                let message = json["message"].stringValue
                let code = json["cod"].stringValue
                if code != "200" {
                    failure(RequestError(code: "\(code)", message: message, error: nil))
                } else {
                    completion(json)
                }
            }
        })
    }
}
