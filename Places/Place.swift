//
//  Place.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/26/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON


class IconURLConstructor {
    private let size = "300x300"
    private var prefix: String
    private var sufix: String
    
    init?(json: JSON) {
        guard let prefix = json["prefix"].string,
            suffix = json["suffix"].string else { return nil }
        
        self.prefix = prefix
        self.sufix = suffix
    }
    
    func assembleURL() -> NSURL? {
        return NSURL(string: "\(prefix)\(size)\(sufix)")
    }
}


class PlaceIconURL {
    private var placeIconURL: NSURL?
    let placeId: String
    
    init(placeId: String) {
        self.placeId = placeId
    }
    
    func palaceIconURL(completion: (NSURL?) -> ()) {
        
        if let url = placeIconURL {
            completion(url)
        } else {
            ServerManager.sharedManager.getVenueIcon(placeId) {[weak self] result in
                if case .Success(let iconConstructor as IconURLConstructor) = result {
                    let url = iconConstructor.assembleURL()
                    self?.placeIconURL = url
                    completion(url)
                }
                if case .Failure(_) = result {
                    completion(nil)
                }
            }
        }
    }
}


class Place: NSObject, MKAnnotation {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let name: String?
    let phone: String?
    let address: String?
    var placeIconURL: PlaceIconURL?
    var title: String? { return name }
    var subtitle: String? { return phone }
    
    init?(json: JSON) {
        guard let id = json["id"].string,
            lat = json["location"]["lat"].double,
            long = json["location"]["lng"].double else { return nil }
        
        self.id = id
        self.coordinate = CLLocationCoordinate2DMake(lat, long)
        self.name = json["name"].string
        self.phone = json["contact"]["formattedPhone"].string
        self.address = json["address"].string
        self.placeIconURL = PlaceIconURL(placeId: id)
    }
}