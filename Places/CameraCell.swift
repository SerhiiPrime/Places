//
//  CameraCell.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/27/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import UIKit

class CameraCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CameraCell"
    
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var cameraTitle: UILabel!
    
    private let placeholder: UIImage = {
        return UIImage(named: "place_placeholder")!
    }()
    
    var surfCam: SurfCamera! {
        didSet {
            updateUI()
        }
    }
    
    
    func updateUI() {
        cameraTitle.text = self.surfCam?.camTitle

        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos , 0)) { () -> Void in
            guard let imageData = NSData(contentsOfURL: NSURL(string:(self.surfCam?.camImage)!)!) else { return }
            let image = UIImage(data:imageData)

            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.cameraImageView?.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cameraTitle.text = nil
        cameraImageView.image = self.placeholder
    }
}
