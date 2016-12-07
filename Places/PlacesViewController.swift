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
    var activityIndicator: UIActivityIndicatorView?
    var canSelectRow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLocationManager()
        fetchData(GlobalConstants.DefauptParams.defaultQuery)
        
    }
    
    func configureUI() {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        actInd.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = .white
        self.view.addSubview(actInd)
        activityIndicator = actInd
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
                locationManager.requestLocation()
            }
        }
    }
    
    func fetchData(_ query: String) {
        ServerManager.sharedManager.fetchNearbyVenues(lat: fetchLocation.coordinate.latitude, long: fetchLocation.coordinate.longitude, query: query) { [weak self] result in
    
            if case .success(let places) = result {
                self?.places = (places as! [Place])
                self?.collectionView.reloadData()
            }
            if case .failure(let error) = result {
                self?.handleError(error)
            }
        }
    }
    
    func handleError(_ error: Error) {
        print("*** Error while fetching places \(error)")
    }
    
    @IBAction func viewOnMapAction(_ sender: AnyObject) {
        performSegue(withIdentifier: GlobalConstants.SegueIdentifiers.mapViewController, sender: places)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GlobalConstants.SegueIdentifiers.mapViewController {
            let mapVC = segue.destination as! MapViewController
            mapVC.places = sender as! [Place]
        } else if segue.identifier == GlobalConstants.SegueIdentifiers.placeDetailsViewController {
            let detVC = segue.destination as! PlaceDetailsViewController
            detVC.place = sender as! PlaceDetails
        }
    }
}


extension PlacesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceCell.reuseIdentifier, for: indexPath) as? PlaceCell else { return UICollectionViewCell() }
        cell.place = places[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "PlacesHeader", for: indexPath)
            return header
        }
        return UICollectionReusableView()
    }
}


extension PlacesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if canSelectRow {
            canSelectRow = false
            ServerManager.sharedManager.getVenueDetails(places[indexPath.row].id) { [weak self] result in
                self?.canSelectRow = true
                if case .success(let details) = result {
                    self?.performSegue(withIdentifier: GlobalConstants.SegueIdentifiers.placeDetailsViewController, sender: details)
                }
            }
            
        }
    }
}


extension PlacesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let queryString = searchController.searchBar.text ?? ""
        
        if queryString != "" {
            fetchData(queryString)
        }
    }
}


extension PlacesViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {return}
        fetchLocation = location
        print("*** --- fetched location \(fetchLocation)")
        fetchData(GlobalConstants.DefauptParams.defaultQuery)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("*** Location Manager did Fail With Error \(error)")
    }
}
