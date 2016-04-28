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
    
    var places:[AmazingFind] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        places = AmazingFind.loadPlaces()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == GlobalConstants.SegueIdentifiers.cameraPlayerViewController {
            let camVC = segue.destinationViewController as! CameraPlayerViewController
            camVC.camera = sender as! SurfCamera
        }
    }
}


extension AmazingFindsViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AmazingFindCell.reuseIdentifier, forIndexPath: indexPath) as? AmazingFindCell else { return UICollectionViewCell() }
        cell.place = places[indexPath.row]
        return cell
    }
}


extension AmazingFindsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //performSegueWithIdentifier(GlobalConstants.SegueIdentifiers.cameraPlayerViewController, sender: surfCams[indexPath.row])
    }
}