//
//  APIRouter.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/26/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import Foundation
import Alamofire


enum APIRouter: URLRequestConvertible {
    
    case searchVenues(lat: Double, long: Double, query: String)
    case venueIcon(id: String)
    case venueDetails(id: String)
    
    static let baseURLString = Settings.API.baseURLString
    
    var method: HTTPMethod{
        switch self {
        case .searchVenues,
             .venueIcon,
             .venueDetails:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .searchVenues:
            return "venues/search"
            
        case .venueIcon(let id):
            return "venues/\(id)/photos"
            
        case .venueDetails(let id):
            return "venues/\(id)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .searchVenues(let lat, let long, let query):
            return ["client_id":        Settings.API.clientID,
                    "client_secret":    Settings.API.clientSecret,
                    "v":                Settings.API.versionOfAPI,
                    "ll":               "\(lat),\(long)",
                    "query":            query]
            
        case .venueIcon:
            return ["client_id":        Settings.API.clientID,
                    "client_secret":    Settings.API.clientSecret,
                    "v":                Settings.API.versionOfAPI,
                    "limit":            "1"]
            
        case .venueDetails:
            return ["client_id":        Settings.API.clientID,
                    "client_secret":    Settings.API.clientSecret,
                    "v":                Settings.API.versionOfAPI]
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try APIRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        return try encoding.encode(urlRequest, with: parameters)
    }
}
