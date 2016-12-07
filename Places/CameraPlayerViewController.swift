//
//  CameraPlayerViewController.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/27/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import UIKit
import AVKit

class CameraPlayerViewController: UIViewController {

    var playerVC = AVPlayerViewController()
    var camera: SurfCamera!
    var camUrl: URL?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let url = URL(string: camera.camURL) {
            camUrl = url
            playerVC.player = AVPlayer(url: camUrl!)
            playerVC.player?.play()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        playerVC = segue.destination as! AVPlayerViewController
    }
}
