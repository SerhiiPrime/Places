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
    var camUrl: NSURL?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let url = NSURL(string: camera.camURL) {
            camUrl = url
            playerVC.player = AVPlayer(URL: camUrl!)
            playerVC.player?.play()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        playerVC = segue.destinationViewController as! AVPlayerViewController
    }
}
