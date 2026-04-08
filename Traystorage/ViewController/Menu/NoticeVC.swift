//
//  NoticeVC.swift
//  Traystorage
//

import Foundation
import UIKit
import SVProgressHUD

class NoticeVC: BaseVC {
    @IBOutlet weak var tvList: UITableView!
    
    var noticeList: [ModelNotice] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        addHeaderSeparator()
        
//        loadNoticeList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNoticeList()
    }
    
    override func removeFromParent() {
    }
    
    func initVC() {
        tvList.register(UINib(nibName: "tvc_notice", bundle: nil), forCellReuseIdentifier: "NoticeTVC")
        tvList.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
    }
}

//
// MARK: - RestApi
//
extension NoticeVC: BaseRestApi {
    func loadNoticeList() {
        LoadingDialog.show()
        Rest.getNoticeList(success: { [weak self](result) -> Void in
            LoadingDialog.dismiss()
            
            let noticeList = result! as! ModelNoticeList
            self?.noticeList.removeAll()
            self?.noticeList.append(contentsOf: noticeList.list)
            self?.tvList.reloadData()
        }) { [weak self](_, err) -> Void in
            LoadingDialog.dismiss()
            self?.view.showToast(err)
        }
    }
}

//
// MARK: - UITableViewDataSource, UITableViewDelegate
//
extension NoticeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTVC", for: indexPath) //as! NoticeTVC
        
        let notice = noticeList[indexPath.row]
        
        if let titleLabel = cell.viewWithTag(1) as? UILabel {
            titleLabel.text = notice.title
        }
        
        if let dateLabel = cell.viewWithTag(2) as? UILabel {
            dateLabel.text = notice.reg_time
        }
        
        if let imageView = cell.viewWithTag(3) as? UIImageView {
            imageView.isHidden = (notice.view_count > 0)
        }
        
        if notice.view_count > 0 {
            cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor = AppColor.notice_UnreadBackColor
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notice = noticeList[indexPath.row]
        notice.view_count += 1
        tableView.reloadRows(at: [indexPath], with: .automatic)
        self.pushVC(NoticeDetailVC(nibName: "vc_notice_detail", bundle: nil), animated: true, params:["id": noticeList[indexPath.row].notice_id])
    }
}
