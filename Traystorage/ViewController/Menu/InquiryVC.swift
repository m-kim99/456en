//
//  InquiryVC.swift
//  Traystorage
//

import Foundation
import UIKit
import SVProgressHUD

class InquiryVC: BaseVC {
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var vwEmpty: UIView!
    @IBOutlet weak var tvList: UITableView!
    @IBOutlet weak var lblCount: UILabel!
    
    var askList:[ModelCard] = []
    var askListExpend:[Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        addHeaderSeparator()
        
        updateList()
    }
    
    private func refreshList() {
        self.tvList.reloadData()
        vwEmpty.isHidden = !self.askList.isEmpty
        vwContent.isHidden = self.askList.isEmpty
        lblCount.text = "\(self.askList.count)"
    }
    
    func initVC() {
        tvList.register(UINib(nibName: "tvc_inquiry", bundle: nil), forCellReuseIdentifier: "InquiryTVC")
        vwEmpty.isHidden = true
    }

    @IBAction func onContactus(_ sender: Any) {
        let vc = ContactusVC(nibName: "vc_contactus", bundle: nil)
        vc.popDelegate = self
        self.pushVC(vc, animated: true)
    }
    
    
    private func listChanged() {
        tvList.reloadData()
        vwEmpty.isHidden = !self.askList.isEmpty
        vwContent.isHidden = self.askList.isEmpty
        lblCount.text = "\(self.askList.count)" + "doc_gon"._localized
    }
}

//
// MARK: - RestApi
//
extension InquiryVC: BaseRestApi {
    func updateList() {
        LoadingDialog.show()
        Rest.getAskList(success: { [weak self] (result) -> Void in
            LoadingDialog.dismiss()

            self?.askList.removeAll()
            
            let cardList = result as! ModelCardList
            for card in cardList.list {
                if card != nil {
                    self?.askList.append(card!)
                    self?.askListExpend.append(false)
                }
            }

            self?.listChanged()
        }) { [weak self] (_, err) -> Void in
            LoadingDialog.dismiss()
            self?.view.showToast(err)
        }
    }
}

//
// MARK: - UITableViewDataSource, UITableViewDelegate
//
extension InquiryVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return askList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InquiryTVC", for: indexPath) as! InquiryTVC
        
        let index = indexPath.row
        let ask = askList[index]
        cell.lblTitle.text = ask.title
        cell.lblDate.text = ask.regTime
        cell.lblDetail.text = ask.content
        cell.lblAnswer.text = ask.reply
        
        cell.isExpand = askListExpend[index]
        
        if ask.status == 0 {
            cell.lblType.superview?.backgroundColor = UIColor(hex: 0xD0d7ff)
            cell.lblType.textColor = UIColor(hex:0x1E319D);
            cell.lblType.text = "reply_wait"._localized
        } else {
            cell.lblType.superview?.backgroundColor = UIColor(hex: 0xe7ebf1)
            cell.lblType.textColor = UIColor(hex:0x666666);
            cell.lblType.text = "answer_done"._localized
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        askListExpend[index] = !askListExpend[index]
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


extension InquiryVC: PopViewControllerDelegate {
    func onWillBack(_ sender: String, _ result: Any?) {
        if result as! String == "updated" {
            updateList()
        }
    }
    
    
}
