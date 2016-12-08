//
//  CameraCell.swift
//  Places
//
//  Created by Serhii Onopriienko on 4/27/16.
//  Copyright © 2016 Serhii Onopriienko. All rights reserved.
//

import UIKit
import AlamofireImage

class CameraCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CameraCell"
    
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var cameraTitle: UILabel!
    
    fileprivate let placeholder: UIImage = {
        return UIImage(named: "place_placeholder")!
    }()
    
    var surfCam: SurfCamera! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        cameraTitle.text = self.surfCam?.camTitle
        guard let imgUrlString = surfCam?.camImage else {return}
        guard let imgUrl = URL(string:imgUrlString) else {return}
        cameraImageView.af_setImage(withURL: imgUrl, placeholderImage: placeholder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cameraTitle.text = nil
        cameraImageView.image = self.placeholder
    }
}
