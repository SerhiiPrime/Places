//
//  PlacesViewController.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/26/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var places:[Place] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData("Infinite loop")
    }
    
    func fetchData(query: String) {
        ServerManager.sharedManager.fetchNearbyVenues(lat: 37.332112, long: -122.0329646, query: query) { [weak self] result in
    
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
        print("*** Error while refreshing cashpoints \(error)")
    }
}


extension PlacesViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PlaceCell.reuseIdentifier, forIndexPath: indexPath) as! PlaceCell
        cell.place = places[indexPath.row]
        return cell
    }
}


extension PlacesViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("select")
    }
}


extension PlacesViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let queryString = searchController.searchBar.text ?? ""
        fetchData(queryString)
    }
}
