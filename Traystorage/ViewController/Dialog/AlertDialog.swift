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
