//
//  MapViewController.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/27/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var places:[Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateAnnotations()
    }
    
    private func configureUI() {
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
    }
    
    private func updateAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(places)
        mapView.showAnnotations(places, animated: true)
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if  let annotation = annotation as? Place {
            let identifier = "pin"
            let view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            view.canShowCallout = true
            // FIXME: make an extension on UIColor for key colors
            view.pinTintColor = UIColor.init(red: 0.0/255.0, green: 169.0/255.0, blue: 120.0/255.0, alpha: 255.0/255.0)
            
            let button = UIButton(type: .Custom)
            button.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            button.backgroundColor = UIColor.redColor()
            view.rightCalloutAccessoryView = button

            return view
        }
        return nil
    }
}

