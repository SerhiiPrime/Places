//
//  SurfCamera.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/27/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import Foundation

class SurfCamera {
    
    var camTitle = String()
    var camURL = String()
    var camImage = String()
    
    init(surfDict:NSDictionary){
        
        guard let title = surfDict["spot"] as? String else { return }
        guard let url = surfDict["url"] as? String else { return }
        guard let image = surfDict["image"] as? String else { return }
        
        self.camTitle = title
        self.camURL = url
        self.camImage = image
    }
    
    // Load cameras from plist file.
    class func loadCameras() -> [SurfCamera] {
        
        var allTheCams = [SurfCamera]()
        guard let filePath = Bundle.main.path(forResource: "CamsSource", ofType: "plist") else { return [] }
        
        if let camsFromArray = NSArray(contentsOfFile: filePath) {
            for dictionary in camsFromArray {
                let surfCam = SurfCamera(surfDict: dictionary as! NSDictionary)
                allTheCams.append(surfCam)
            }
        }
        return allTheCams
    }
}
