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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GlobalConstants.SegueIdentifiers.cameraPlayerViewController {
            let camVC = segue.destination as! CameraPlayerViewController
            camVC.camera = sender as! SurfCamera
        }
    }
}


extension WebCamViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surfCams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CameraCell.reuseIdentifier, for: indexPath) as? CameraCell else { return UICollectionViewCell() }
        cell.surfCam = surfCams[indexPath.row]
        return cell
    }
}


extension WebCamViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: GlobalConstants.SegueIdentifiers.cameraPlayerViewController, sender: surfCams[indexPath.row])
    }
}
