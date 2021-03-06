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
    var iconConstructor: IconURLConstructor?
    
    init?(json: JSON) {
        guard let id = json["id"].string,
            let lat = json["location"]["lat"].double,
            let long = json["location"]["lng"].double else { return nil }
        
        self.id = id
        self.coordinate = CLLocationCoordinate2DMake(lat, long)
        self.name = json["name"].string
        self.phone = json["contact"]["formattedPhone"].string
        self.address = json["location"]["formattedAddress"][0].string
        self.rating = json["rating"].double
        self.ratingColor = json["ratingColor"].string
        self.reasonSummary = json["description"].string
        self.hoursStatus = json["hours"]["status"].string
        
        if let pref = json["bestPhoto"]["prefix"].string, let suf = json["bestPhoto"]["suffix"].string {
            self.iconConstructor = IconURLConstructor(pref: pref, suf:  suf)
        }
    }
}


class IconURLConstructor {
    fileprivate let sizeSmal = "300x300"
    fileprivate let sizeBig = "600x600"
    fileprivate var prefix: String
    fileprivate var sufix: String
    
    init?(json: JSON) {
        guard let prefix = json["prefix"].string,
            let suffix = json["suffix"].string else { return nil }
        
        self.prefix = prefix
        self.sufix = suffix
    }
    
    init(pref: String, suf: String) {
        self.prefix = pref
        self.sufix = suf
    }
    
    func assembleSmalURL() -> URL? {
        return URL(string: "\(prefix)\(sizeSmal)\(sufix)")
    }
    
    func assembleBigURL() -> URL? {
        return URL(string: "\(prefix)\(sizeBig)\(sufix)")
    }
}
