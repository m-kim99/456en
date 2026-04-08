//
//  AgreeTVC.swift
//  Traystorage
//
//

import Foundation
import UIKit

protocol AgreeTableCellDelegate: NSObjectProtocol {
    func onClickCheckItem(at: IndexPath)
    
    func onClickView(at: IndexPath)
}

class AgreeTVC: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    weak var agreeDelgate: AgreeTableCellDelegate?
    var isChecked = false
    
    
    func setAgreeData(agree: ModelAgreement, isChecked: Bool) {
        
        var title = agree.title
        if agree.status == 0 {
            title += " " + "agree_item_req_suffix"._localized
        }
        
        titleLabel.text = title
        self.isChecked = isChecked
        updateCheckImage()
    }
    
    private func updateCheckImage() {
        let checkImage = "Icon-C-Check-24"
        let disableCheckImage = "Icon-C-Check-Gray-24 Copy"
        let imageName = isChecked ? checkImage : disableCheckImage
        checkImageView.image = UIImage(named: imageName)
    }
    
    
    @IBAction func onClickCheckItem(_ sender: Any) {
        guard let agreeDelgate = self.agreeDelgate, let tableView = self.tableView, let indexPath = tableView.indexPath(for: self) else {
            return
        }
        
        isChecked = !isChecked
        updateCheckImage()
        
        agreeDelgate.onClickCheckItem(at: indexPath)
    }
    
    
    @IBAction func onClickView(_ sender: Any) {
        guard let agreeDelgate = self.agreeDelgate, let tableView = self.tableView, let indexPath = tableView.indexPath(for: self) else {
            return
        }
        
        agreeDelgate.onClickView(at: indexPath)
    }
}
