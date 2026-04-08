//
//  FaqTVC.swift
//  Traystorage
//

import UIKit

protocol LicenseTVCDelegate {
    
}

class LicenseTVC: UITableViewCell {
    @IBOutlet weak var vwRoot: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLink: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    private var dataModel: ModelFAQ!
    private var delegate: LicenseTVCDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data: ModelFAQ, delegate: LicenseTVCDelegate) {
        self.dataModel = data
        self.delegate = delegate
    }
    
    //
    // MARK: - Action
    //
}
