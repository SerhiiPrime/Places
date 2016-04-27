//
//  WebCamViewController.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/26/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import UIKit

class WebCamViewController: UIViewController {

    @IBOutlet weak var cellectionView: UICollectionView!
    
    var surfCams:[SurfCamera] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        surfCams = SurfCamera.loadCameras()
    }

}


extension WebCamViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surfCams.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CameraCell.reuseIdentifier, forIndexPath: indexPath) as? CameraCell else { return UICollectionViewCell() }
        cell.surfCam = surfCams[indexPath.row]
        return cell
    }
}


extension WebCamViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //performSegueWithIdentifier(GlobalConstants.SegueIdentifiers.mapViewController, sender: [places[indexPath.row]])
    }
}