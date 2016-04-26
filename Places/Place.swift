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


struct PlaceIcon {
    let id: String
    let prefix: String
    let sufix: String
    
    init?(json: JSON) {
        guard let id = json["id"].string,
            prefix = json["prefix"].string,
            suffix = json["suffix"].string else { return nil }
        
        self.id = id
        self.prefix = prefix
        self.sufix = suffix
    }
}


class Place: NSObject, MKAnnotation {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let name: String?
    let phone: String?
    let address: String?
    let icon: PlaceIcon?
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
        self.icon = PlaceIcon(json: json["categories"])
    }
}