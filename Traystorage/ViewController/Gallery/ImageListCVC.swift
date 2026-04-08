//
//  ImageListCVC.swift
//  Dabada
//
//  Created by flower on 2/9/18.
//  Copyright © 2018 Smith. All rights reserved.
//

import UIKit

class ImageListCVC: UICollectionViewCell {
    
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var imageParent: UIView!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var vwEffect: UIView!
    @IBOutlet weak var lbNumber: UILabel!
    
    var representedAssetIdentifier : String!
    
    var selectedIndex = 0 {
        didSet {
            let selectedColor = AppColor.active
            if selectedIndex < 0 {
                vwEffect.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                vwEffect.borderWidth = 2
                vwEffect.borderColor = AppColor.white
                
                imageParent.borderColor = nil
                imageParent.borderWidth = 0
                lbNumber.text = nil
            } else {
                vwEffect.backgroundColor = selectedColor
                vwEffect.borderWidth = 0
                
                imageParent.borderColor = selectedColor
                imageParent.borderWidth = 2
                lbNumber.text = "\(selectedIndex + 1)"
            }
        }
    }
    
    var isCameraCell = false {
        didSet {
            cameraImageView.isHidden = !isCameraCell
            imageParent.isHidden = isCameraCell
        }
    }
}
