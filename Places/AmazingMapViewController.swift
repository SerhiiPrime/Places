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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateMapView()
    }
    
    private func configureUI() {
        mapView.mapType = .SatelliteFlyover
        mapView.showsScale = true
        mapView.showsBuildings = true
    }
    
    private func updateMapView() {
        
        if let coordinates = place?.coordinate {
            let camera = MKMapCamera(lookingAtCenterCoordinate: coordinates,fromEyeCoordinate: coordinates, eyeAltitude: 1000.0)
            mapView.setCamera(camera, animated: false)
        }
    }
}
