//
//  FaqCVC.swift
//  Traystorage
//

import UIKit

class FaqCVC: UICollectionViewCell {
    @IBOutlet weak var vwRoot: UIView!
    @IBOutlet weak var lblText: UILabel!

    
    func setData(text: String, isSelect: Bool) {
        lblText.text = text
        
        if isSelect {
            lblText.textColor = AppColor.white
            vwRoot.backgroundColor = AppColor.black
        } else {
            lblText.textColor = AppColor.black
            vwRoot.backgroundColor = UIColor.clear
        }
    }
}
