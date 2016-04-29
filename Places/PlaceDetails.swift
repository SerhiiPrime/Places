//
//  PlaceDetails.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/29/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON


class PlaceDetails: NSObject, MKAnnotation {
    
    let id: String
    let name: String?
    let phone: String?
    let coordinate: CLLocationCoordinate2D
    let address: String?
    var title: String? { return name }
    var subtitle: String? { return phone }
    let rating: Double?
    let ratingColor: String?
    let reasonSummary: String?
    let hoursStatus: String?
    
    init?(json: JSON) {
        guard let id = json["id"].string,
            lat = json["location"]["lat"].double,
            long = json["location"]["lng"].double else { return nil }
        
        self.id = id
        self.coordinate = CLLocationCoordinate2DMake(lat, long)
        self.name = json["name"].string
        self.phone = json["contact"]["formattedPhone"].string
        self.address = json["location"]["formattedAddress"].string
        self.rating = json["rating"].double
        self.ratingColor = json["ratingColor"].string
        self.reasonSummary = json["reasons"]["items"]["summary"].string
        self.hoursStatus = json["hours"]["status"].string
    }
}