//
//  ServerManager.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/26/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


typealias CompletionHandlerType = (Result) -> Void

enum Result {
    case Success(AnyObject?)
    case Failure(ErrorType)
}


class ServerManager {
    
    struct Error: ErrorType {
        var code: StatusCode
        var message: String
        
        init(code: Int, message: String) {
            self.code = StatusCode(rawValue: code) ?? .Failure
            self.message = message
        }
        
        init(code: StatusCode, message: String) {
            self.code = code
            self.message = message
        }
    }
    
    enum StatusCode: Int {
        case Success        = 200
        case Failure        = 1000
    }
    
    
    static let sharedManager = ServerManager()
    
    
    func fetchNearbyVenues(lat lat: Double, long: Double, query: String, completion: CompletionHandlerType) {
        
        Alamofire.request(APIRouter.SearchVenues(lat, long, query)).validate().responseJSON { response in
            
            guard response.result.isSuccess else {
                print("*** Error while fetching venues: \(response.result.error!)")
                completion(.Failure(response.result.error!))
                return
            }
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                fatalError("*** Unexpected json repsonse")
            }
            
            let json = JSON(responseJSON)
            print("*** \(#function)\n")
            
            guard StatusCode(rawValue: json["meta"]["code"].intValue) == .Success else {
                print("*** Server error: \(json["Error"])")
                completion(.Failure(Error(code: json["StatusCode"].intValue, message: json["Error"].stringValue)))
                return
            }
            
            var venues:[Place] = []
            for venue in json["response"]["venues"].array! {
                if let v = Place(json: venue) {
                    venues.append(v)
                }
            }
            completion(.Success(venues))
        }
    }
    
    func getVenueIcon(id: String, completion: CompletionHandlerType) -> NSURLSessionTask {
        
        let request = Alamofire.request(APIRouter.VenueIcon(id)).validate().responseJSON { response in
            
            guard response.result.isSuccess else {
                print("*** Error while venue icon: \(response.result.error!)")
                completion(.Failure(response.result.error!))
                return
            }
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                fatalError("*** Unexpected json repsonse")
            }
            
            let json = JSON(responseJSON)
            
            guard StatusCode(rawValue: json["meta"]["code"].intValue) == .Success else {
                print("*** Server error: \(json["Error"])")
                completion(.Failure(Error(code: json["StatusCode"].intValue, message: json["Error"].stringValue)))
                return
            }
            
            if let iconUrl = IconURLConstructor(json: json["response"]["photos"]["items"][0]) {
                completion(.Success(iconUrl))
            } else {
                completion(.Failure(Error(code: -1, message: "no images")))
            }
        }
        
        return request.task
    }
    
    func getVenueDetails(id: String, completion: CompletionHandlerType) {
        
        Alamofire.request(APIRouter.VenueDetails(id)).validate().responseJSON { response in
            
            guard response.result.isSuccess else {
                print("*** Error while venue details: \(response.result.error!)")
                completion(.Failure(response.result.error!))
                return
            }
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                fatalError("*** Unexpected json repsonse")
            }
            
            let json = JSON(responseJSON)
            
            guard StatusCode(rawValue: json["meta"]["code"].intValue) == .Success else {
                print("*** Server error: \(json["Error"])")
                completion(.Failure(Error(code: json["StatusCode"].intValue, message: json["Error"].stringValue)))
                return
            }
            
            if let v = PlaceDetails(json: json["response"]["venue"]) {
                completion(.Success(v))
            } else {
                completion(.Failure(Error(code: -1, message: "no details")))
            }
        }
    }
}
