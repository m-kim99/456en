import Foundation
import UIKit

class ConfirmDialog: UIViewController {
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var vwRoot: UIView!
    
    public typealias Callback = () -> ()
    public typealias CallbackWith = (_ ret:Int?) -> ()

    private var okAction: Callback?
    private var retAction: CallbackWith?

    private var caption: String!
    private var content: String!
    private var showCancelBtn = false
    private var okTitle: String?
    private var cancelTitle: String?

    static func show(_ vc: UIViewController,
                     title: String!,
                     message: String!,
                     showCancelBtn: Bool!,
                     okAction: Callback? = nil) {
        let popup = ConfirmDialog("dialog_confirm", title: title, message: message, showCancelBtn: showCancelBtn, okAction: okAction)
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        vc.present(popup, animated: true, completion: nil)
    }
    
    static func show2(_ vc: UIViewController,
                     title: String!,
                     message: String!,
                     showCancelBtn: Bool!,
                     okAction: Callback? = nil) {
        let popup = ConfirmDialog("dialog_confirm_v2", title: title, message: message, showCancelBtn: showCancelBtn, okAction: okAction)
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        vc.present(popup, animated: true, completion: nil)
    }
    
    static func show3(_ vc: UIViewController,
                     title: String!,
                     message: String!,
                     okTitle: String? = nil,
                     cancelTitle: String? = nil,
                     retAction: CallbackWith? = nil) {
        let popup = ConfirmDialog("dialog_confirm", title: title, message: message, okTitle: okTitle, cancelTitle: cancelTitle, retAction: retAction)
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        vc.present(popup, animated: true, completion: nil)
    }
    
    convenience init(_ nibName: String?, title: String!, message: String!, showCancelBtn: Bool!, okAction: Callback?) {
        self.init(nibName: nibName, bundle: nil)
        
        self.caption = title
        self.content = message
        self.okAction = okAction
        self.retAction = nil
        self.showCancelBtn = showCancelBtn
    }
    
    convenience init(_ nibName: String?, title: String!, message: String!, okTitle: String?, cancelTitle:String?, retAction: CallbackWith?) {
        self.init(nibName: nibName, bundle: nil)
        
        self.caption = title
        self.content = message
        self.okAction = nil
        self.retAction = retAction
        self.showCancelBtn = showCancelBtn
        
        self.okTitle = okTitle
        self.cancelTitle = cancelTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = caption
        lblContent.text = content
//        btnYes.setTitle(getLangString("confirm"), for: .normal)
//        btnCancel.setTitle(getLangString("cancel"), for: .normal)
        
        if let title = okTitle {
            self.btnYes.setTitle(title, for: .normal)
        }
        if let title = cancelTitle {
            self.showCancelBtn = true
            self.btnCancel.setTitle(title, for: .normal)
        }
        
        if (self.showCancelBtn == false) {
            self.btnCancel.isHidden = true
//            let newConstraint = self.constraintBtnYes.constraintWithMultiplier(1)
//            self.view!.removeConstraint(self.constraintBtnYes)
//            self.view!.addConstraint(constraintBtnYes)
//            self.view!.layoutIfNeeded()
        }
        
        vwBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onClickNo(_:))))
        
        vwRoot.frame = UIScreen.main.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //
    // MARK: - Action
    //
    @IBAction func onClickYes(_ sender: Any) {
        dismiss(animated: true) {
            self.view.removeFromSuperview()
            self.removeFromParent()
            if let act = self.retAction {
                act(0)
            } else {
                self.okAction?()
            }
        }
    }
    
    @IBAction func onClickNo(_ sender: Any) {
        dismiss(animated: true) {
            self.view.removeFromSuperview()
            self.removeFromParent()
            if let act = self.retAction {
                act(1)
            }
        }
    }
}

