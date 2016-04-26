//
//  PlacesViewController.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/26/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        ServerManager.sharedManager.fetchNearbyVenues(lat: 37.332112, long: -122.0329646, query: "Infinite loop") { result in
            print(result)
        }
    }

}


extension PlacesViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //filterString = searchController.searchBar.text ?? ""
    }
}
