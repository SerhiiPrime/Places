//
//  Amazing FindsViewController.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/28/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import UIKit

class AmazingFindsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var places:[AmazingFind] = AmazingFind.loadPlaces()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GlobalConstants.SegueIdentifiers.amazingMapViewController {
            let mapVC = segue.destination as! AmazingMapViewController
            mapVC.place = sender as? AmazingFind
        }
    }
}


extension AmazingFindsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AmazingFindCell.reuseIdentifier, for: indexPath) as? AmazingFindCell else { return UICollectionViewCell() }
        cell.place = places[indexPath.row]
        return cell
    }
}


extension AmazingFindsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: GlobalConstants.SegueIdentifiers.amazingMapViewController, sender: places[indexPath.row])
    }
}
