import Foundation
import UIKit

class AlertDialog: UIViewController {
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var vwRoot: UIView!
    
    public typealias Callback = () -> ()
    
    private var okAction: Callback?
    
    private var caption: String!
    private var content: String!
    private var okTitle: String!
    
    static func show(_ vc: UIViewController,
                     title: String!,
                     message: String!,
                     okAction: Callback? = nil) {
        show(vc, title: title, message: message, okTitle: "confirm"._localized, okAction: okAction)
    }
    
    static func show(_ vc: UIViewController,
                     title: String!,
                     message: String!,
                     okTitle: String!,
                     okAction: Callback?) {
        
        let popup = AlertDialog("dialog_alert", title: title, message: message, okTitle: okTitle, okAction: okAction)
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        vc.present(popup, animated: true, completion: nil)
    }
    
    convenience init(_ nibName: String?, title: String!, message: String!, okTitle: String!, okAction: Callback?) {
        self.init(nibName: nibName, bundle: nil)
        
        self.caption = title
        self.content = message
        self.okTitle = okTitle
        self.okAction = okAction
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = caption
        lblContent.text = content
        btnYes.setTitle(okTitle, for: .normal)
        
        //lblTitle.setTitleFont()
        //lblContent.setRegularFont(13)
        //btnYes.setButtonFont()
        
        vwBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onClickNo(_:))))
        vwRoot.frame = UIScreen.main.bounds
        
        // Android-style: text-only button, no background/border
        // Confirm: #1E319D, 16sp, bold
        btnYes.backgroundColor = .clear
        btnYes.layer.borderWidth = 0
        btnYes.layer.cornerRadius = 0
        let confirmColor = UIColor(red: 30.0/255.0, green: 49.0/255.0, blue: 157.0/255.0, alpha: 1.0)
        btnYes.setTitleColor(confirmColor, for: .normal)
        btnYes.tintColor = confirmColor
        btnYes.titleLabel?.font = AppFont.createBoldFont(name: AppFont.fontFamilyName, size: 16)
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
            self.okAction?()
        }
    }
    
    @IBAction func onClickNo(_ sender: Any) {
        dismiss(animated: true) {
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}
