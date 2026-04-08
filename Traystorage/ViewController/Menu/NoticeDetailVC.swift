//
//  NoticeVC.swift
//  Traystorage
//

import Foundation
import UIKit
import SVProgressHUD
import WebKit 

class NoticeDetailVC: BaseVC {
    
    @IBOutlet weak var lblTitle: UIFontLabel!
    @IBOutlet weak var lblRegTime: UIFontLabel!
    @IBOutlet weak var wvContent: WKWebView!
    
    var notice: ModelNotice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = nil
        lblRegTime.text = nil
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
//        webView = WKWebView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 50)), configuration: configuration)
        wvContent.backgroundColor = AppColor.white
        wvContent.scrollView.backgroundColor = AppColor.white
        wvContent.isOpaque = false
        
        if let noticeID = params["id"] as? Int {
            loadNotice(noticeID: noticeID)
        } else if let noticeCode = params["code"] as? String {
            loadNotice(noticeCode: noticeCode)
        }
    }
    
    private func loadContents() {
        if let notice = notice {
            lblTitle.text = notice.title
            lblRegTime.text = notice.reg_time
            
//            var tempContents: NSString! = notice.content! as NSString
//            tempContents = tempContents.htmlString(byAppendingStyles: false)! as NSString
//            tempContents = tempContents.htmlStringByAppendingBodyStyle(withName: "word-wrap", contents: "break-word")! as NSString
//            tempContents = tempContents.htmlStringByAppendingDeviceWidthMetaInfo()! as NSString
//
            wvContent.loadHTMLString(notice.content, baseURL: nil)
        } else {
            lblTitle.text = nil
            lblRegTime.text = nil
            wvContent.loadHTMLString("", baseURL: nil)
        }
    }
}

//
// MARK: - RestApi
//
extension NoticeDetailVC: BaseRestApi {
    func loadNotice(noticeID: Int) {
        LoadingDialog.show()
        Rest.getNotice(noticeID: noticeID, success: { [weak self](result) -> Void in
            LoadingDialog.dismiss()

            self?.notice = (result as! ModelNotice)
            self?.loadContents()

        }) { [weak self](_, err) -> Void in
            LoadingDialog.dismiss()
            self?.view.showToast(err)
        }
    }
    
    func loadNotice(noticeCode: String) {
        LoadingDialog.show()
        Rest.getNotice(code: noticeCode, success: { [weak self](result) -> Void in
            LoadingDialog.dismiss()

            self?.notice = (result as! ModelNotice)
            self?.loadContents()

        }) { [weak self](_, err) -> Void in
            LoadingDialog.dismiss()
            self?.view.showToast(err)
        }
    }
}
