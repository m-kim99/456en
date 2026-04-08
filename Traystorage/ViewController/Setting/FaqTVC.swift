//
//  FaqTVC.swift
//  Traystorage
//

import UIKit

class FaqTVC: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageExpand: UIImageView!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    private var dataModel: ModelFAQ!
    
    func setData(data: ModelFAQ, isExpand: Bool) {
        lblTitle.text = data.title
        lblSubTitle.text = data.content

        self.lblSubTitle.isHidden = !isExpand
        let image = isExpand ? "ic_arrow_up" : "ic_arrow_down"
        imageExpand.image = UIImage(named: image)
    }
}
