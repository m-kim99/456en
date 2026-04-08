//
//  FaqTVC.swift
//  Traystorage
//

import UIKit

protocol InquiryTVCDelegate {
    
}

class InquiryTVC: UITableViewCell {
    @IBOutlet weak var vwRoot: UIView!
    @IBOutlet weak var imageExpand: UIImageView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    
    var isExpand = false {
        didSet {
            lblDetail.isHidden = !isExpand
            lblAnswer.isHidden = !isExpand || (lblAnswer.text?.isEmpty ?? true)
            let image = isExpand ? "ic_arrow_up" : "ic_arrow_down"
            imageExpand.image = UIImage(named: image)
        }
    }
    
    private var dataModel: ModelFAQ!
    private var delegate: InquiryTVCDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data: ModelFAQ, delegate: InquiryTVCDelegate) {
        self.dataModel = data
        self.delegate = delegate
    }
    
    //
    // MARK: - Action
    //
}
