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


typealias CompletionHandler = (Result<Any, NetworkError>) -> Void


enum Result<T, E: Swift.Error> {
    case success(T)
    case failure(E)
}


struct NetworkError: Swift.Error {
    let code: ErrorCode
    let message: String
    
    init(code: ErrorCode, message: String) {
        self.code = code
        self.message = message
    }
    
    init(error: Swift.Error) {
        self.code = ErrorCode(rawValue: (error as NSError).code) ?? .unknownError
        self.message = error.localizedDescription
    }
}


enum ErrorCode: Int {
    case success              = 200
    case unknownError         = 1000
    case unexpectedJsonValue  = 1001
    case noNetwork            = -1009
}


class ServerManager {
    
    static let sharedManager = ServerManager()
    
    
    func fetchNearbyVenues(lat: Double, long: Double, query: String, completion: @escaping CompletionHandler) {
        
        Alamofire.request(APIRouter.searchVenues(lat: lat, long: long, query: query)).validate().responseJSON { response in
            
            switch response.result {
            case let .success(data):
                
                guard let venuesArray = JSON(data)["response"]["venues"].array else {
                    completion(.failure(NetworkError(code: ErrorCode.unexpectedJsonValue, message: "Unexpected Json Value")))
                    return
                }
            
                var venues:[Place] = []
                for venue in venuesArray {
                    if let v = Place(json: venue) {
                        venues.append(v)
                    }
                }
                completion(.success(venues))
                
            case let .failure(error): completion(.failure(NetworkError(error: error)))
            }
        }
    }
    
    func getVenueIcon(_ id: String, completion: @escaping CompletionHandler) -> URLSessionTask? {
        
        let request = Alamofire.request(APIRouter.venueIcon(id: id)).validate().responseJSON { response in
            
            switch response.result {
            case let .success(data):
                
                if let iconUrl = IconURLConstructor(json: JSON(data)["response"]["photos"]["items"][0]) {
                    completion(.success(iconUrl))
                } else {
                    completion(.failure(NetworkError(code: ErrorCode.unexpectedJsonValue, message: "Unexpected Json Value")))
                }
                
            case let .failure(error): completion(.failure(NetworkError(error: error)))
            }
        }
        
        return request.task
    }
    
    func getVenueDetails(_ id: String, completion: @escaping CompletionHandler) {
        
        Alamofire.request(APIRouter.venueDetails(id: id)).validate().responseJSON { response in
            
            switch response.result {
            case let .success(data):
                
                if let v = PlaceDetails(json: JSON(data)["response"]["venue"]) {
                    completion(.success(v))
                } else {
                    completion(.failure(NetworkError(code: ErrorCode.unexpectedJsonValue, message: "Unexpected Json Value")))
                }
                
            case let .failure(error): completion(.failure(NetworkError(error: error)))
            }
        }
    }
}
