//
//  EveryDayDialog.swift
//  Traystorage
//
//  Created by Dev2 on 2021. 12. 15..
//

import UIKit
import WebKit
import SVProgressHUD

class EveryDayDialog: UIViewController {
    @IBOutlet weak var vwRoot: UIView!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var vwWeb: UIView!
    @IBOutlet weak var ivContent: UIImageView!
    @IBOutlet weak var btnNeverShow: UIButton!
    private var webView: WKWebView!
    
    public typealias Callback = () -> Void
    private var notShowAction: Callback?
    private var closeAction: Callback?
    private var imageAction: Callback?
    private var content: ModelPopup!
    
    static func show(_ vc: UIViewController,
                     content: ModelPopup!, notShowAction: Callback? = nil, closeAction: Callback?, imageAction: Callback?) {
        
        let popup = EveryDayDialog("dialog_everyday", content: content, notShowAction: notShowAction, closeAction: closeAction, imageAction: imageAction)
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        vc.present(popup, animated: true, completion: nil)
    }
    
    convenience init(_ nibName: String?, content: ModelPopup!, notShowAction: Callback?, closeAction: Callback?, imageAction: Callback?) {
        self.init(nibName: nibName, bundle: nil)
        
        self.content = content
        self.notShowAction = notShowAction
        self.closeAction = closeAction
        self.imageAction = imageAction
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if content.closeMethod == 0 {
            btnNeverShow.removeFromSuperview()
        }
        
        initVC()

    }
    
    func initVC() {
        vwBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onClose(_:))))
        vwRoot.frame = UIScreen.main.bounds
        
        if content.contentType == 1 {
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = true
            let configuration = WKWebViewConfiguration()
            configuration.preferences = preferences
            webView = WKWebView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.size.width - 40, height: UIScreen.main.bounds.size.height - 219)), configuration: configuration)
            webView.backgroundColor = AppColor.white
            webView.scrollView.backgroundColor = AppColor.white
            webView.isOpaque = false
            vwWeb.addSubview(webView)
            ivContent.isHidden = true
            
            webView.loadHTMLString(content.content, baseURL: nil);
        } else {
            vwWeb.isHidden = true
            ivContent.kf.setImage(with: URL(string: content.contentImage))
            ivContent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onClickImage(_:))))
        }
        
//        sendViewPopup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func sendViewPopup() {
        LoadingDialog.show()
        Rest.viewPopup(popupId: self.content.id, success:{ [weak self](result) in
            LoadingDialog.dismiss()
        }, failure: { [weak self](code, err) in
            LoadingDialog.dismiss()
            self?.view.showToast(err)
        })
    }
    
    func onClickPopupSuccessed() {
        if content.moveType == 0 {
            guard let url = URL(string: content.movePath) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        } else if content.moveType == 1 {
            dismiss(animated: true) {[weak self] in
                self?.view.removeFromSuperview()
                self?.removeFromParent()
                self?.imageAction?()
            }
        }
    }

    //
    // MARK: - Action
    //
    @IBAction func onNotSeeToday(_ sender: Any) {
        dismiss(animated: true) {
            self.view.removeFromSuperview()
            self.removeFromParent()
            
            self.sendViewPopup()
//            self.notShowAction?()
        }
    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true) {[weak self] in
            self?.view.removeFromSuperview()
            self?.removeFromParent()
            
            if self?.content.closeMethod == 0 {
                self?.sendViewPopup()
            }
        }
    }
    
    @objc func onClickImage(_ sender: Any) {
        LoadingDialog.show()
        Rest.clickPopup(popupId: self.content.id, success:{ [weak self](result) in
            LoadingDialog.dismiss()
            self?.onClickPopupSuccessed()
        }, failure: { [weak self](code, err) in
            LoadingDialog.dismiss()
            self?.view.showToast(err)
        })
    }
}
