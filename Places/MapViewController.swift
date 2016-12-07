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
    
    var venue: PlaceDetails?
    var places:[Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateAnnotations()
    }
    
    fileprivate func configureUI() {
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
    }
    
    fileprivate func updateAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        if let ven = venue {
            mapView.addAnnotations([ven])
            mapView.showAnnotations([ven], animated: true)
        } else {
            mapView.addAnnotations(places)
            mapView.showAnnotations(places, animated: true)
        }
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        return pinAnnotationView(annotation)
    }
    
    func pinAnnotationView(_ annotation: MKAnnotation) -> MKPinAnnotationView {
        
        let view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: GlobalConstants.ViewIdentifiers.pinAnnotationIdentifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: GlobalConstants.ViewIdentifiers.pinAnnotationIdentifier)
        }
        view.canShowCallout = true
        view.pinTintColor = UIColor.mapPinColor()
        return view
    }
}

