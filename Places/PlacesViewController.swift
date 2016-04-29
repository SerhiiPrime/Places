//
//  PlacesViewController.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/26/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import UIKit
import CoreLocation


class PlacesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let locationManager = CLLocationManager()
    var places:[Place] = []
    var fetchLocation = CLLocation(latitude: GlobalConstants.DefauptParams.defaultLat, longitude: GlobalConstants.DefauptParams.defaultLng)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        fetchData(GlobalConstants.DefauptParams.defaultQuery)
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == .AuthorizedAlways {
                locationManager.requestLocation()
            }
        }
    }
    
    func fetchData(query: String) {
        ServerManager.sharedManager.fetchNearbyVenues(lat: fetchLocation.coordinate.latitude, long: fetchLocation.coordinate.longitude, query: query) { [weak self] result in
    
            if case .Success(let places) = result {
                self?.places = (places as! [Place])
                self?.collectionView.reloadData()
            }
            if case .Failure(let error) = result {
                self?.handleError(error)
            }
        }
    }
    
    func handleError(error: ErrorType) {
        print("*** Error while fetching places \(error)")
    }
    
    @IBAction func viewOnMapAction(sender: AnyObject) {
        performSegueWithIdentifier(GlobalConstants.SegueIdentifiers.mapViewController, sender: places)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == GlobalConstants.SegueIdentifiers.mapViewController {
            let mapVC = segue.destinationViewController as! MapViewController
            mapVC.places = sender as! [Place]
        }
    }
}


extension PlacesViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PlaceCell.reuseIdentifier, forIndexPath: indexPath) as? PlaceCell else { return UICollectionViewCell() }
        cell.place = places[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "PlacesHeader", forIndexPath: indexPath)
            return header
        }
        return UICollectionReusableView()
    }
}


extension PlacesViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(GlobalConstants.SegueIdentifiers.mapViewController, sender: [places[indexPath.row]])
    }
}


extension PlacesViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let queryString = searchController.searchBar.text ?? ""
        
        if queryString != "" {
            fetchData(queryString)
        }
    }
}


extension PlacesViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {return}
        fetchLocation = location
        print("*** --- fetched location \(fetchLocation)")
        fetchData(GlobalConstants.DefauptParams.defaultQuery)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("*** Location Manager did Fail With Error \(error)")
    }
}
