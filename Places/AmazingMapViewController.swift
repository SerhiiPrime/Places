//
//  AmazingMapViewController.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/28/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import UIKit
import MapKit

class AmazingMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var place: AmazingFind?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateMapView()
    }
    
    fileprivate func configureUI() {
        mapView.mapType = .satelliteFlyover
        mapView.showsScale = true
        mapView.showsBuildings = true
    }
    
    fileprivate func updateMapView() {
        
        if let coordinates = place?.coordinate {
            let camera = MKMapCamera(lookingAtCenter: coordinates,fromEyeCoordinate: coordinates, eyeAltitude: 1000.0)
            mapView.setCamera(camera, animated: false)
        }
    }
}
