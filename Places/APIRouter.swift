//
//  APIRouter.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/26/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import Foundation
import Alamofire


public enum APIRouter: URLRequestConvertible {
    
    case SearchVenues(Double, Double, String)

    
    public var URLRequest: NSMutableURLRequest {
        let result: (path: String, method: Alamofire.Method, parameters: [String: AnyObject], encoding: Alamofire.ParameterEncoding, headers: [String: String]) = {
            switch self {
                
            case .SearchVenues(let lat, let long, let query):
                let params = [
                    "client_id": Settings.API.clientID,
                    "client_secret": Settings.API.clientSecret,
                    "v": Settings.API.versionOfAPI,
                    "ll": "\(lat),\(long)",
                    "query": query
                ]
                return ("venues/search", .GET, params, .URL, [:])
            }
        }()
        
        let baseURL = NSURL(string: Settings.API.baseURLString)
        let URLRequest = NSMutableURLRequest(URL: baseURL!.URLByAppendingPathComponent(result.path))
        URLRequest.HTTPMethod = result.method.rawValue
        URLRequest.timeoutInterval = NSTimeInterval(60)
        result.headers.forEach { URLRequest.setValue($1, forHTTPHeaderField: $0) }
    
        return result.encoding.encode(URLRequest, parameters: result.parameters).0
    }
}