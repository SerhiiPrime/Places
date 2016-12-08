//
//  AmazingFind.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/28/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import Foundation
import MapKit

class AmazingFind {
    
    var placeTitle = String()
    var placeLocationDescription = String()
    var placeImageUrl = String()
    var coordinate = CLLocationCoordinate2D()
    
    init(dict:NSDictionary){
        
        guard let title = dict["title"] as? String else { return }
        guard let locationDescr = dict["locationDescription"] as? String else { return }
        guard let image = dict["imgUrl"] as? String else { return }
        guard let lat = dict["lat"] as? Double else { return }
        guard let lng = dict["lng"] as? Double else { return }
        
        placeTitle = title
        placeLocationDescription = locationDescr
        placeImageUrl = image
        coordinate = CLLocationCoordinate2DMake(lat, lng)
    }
    
    // Load places from the file.
    class func loadPlaces() -> [AmazingFind] {
        
        var allThePlaces = [AmazingFind]()
        guard let filePath = Bundle.main.path(forResource: "AmazingFinds", ofType: "plist") else { return [] }
        
        if let placesFromArray = NSArray(contentsOfFile: filePath) {
            for dictionary in placesFromArray {
                let place = AmazingFind(dict: dictionary as! NSDictionary)
                allThePlaces.append(place)
            }
        }
        return allThePlaces
    }
}
