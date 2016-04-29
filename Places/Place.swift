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


class Place: NSObject, MKAnnotation {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let name: String?
    let phone: String?
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
    }
}