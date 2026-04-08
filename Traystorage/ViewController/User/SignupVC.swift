import SVProgressHUD
import SwiftyJSON
import Toast_Swift
import UIKit
//import Material

enum SingupStep: Int {
    case first = 0
    case auth = 1
    case agree = 2
    case complete = 3
}

protocol SignupNextDelegate : NSObjectProtocol {
    func onClickNext(step: SingupStep, params: [String: Any])
}

class SignupVC: BaseVC {
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var vwSignupProgress: UIProgressView!
    
    weak var currentSignupPageVC: UIViewController?
    
    private var curTab = AuthType.phone
    
    var snsType = 0
    var snsID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if snsID != "" {
            if gReview {
                let randomInt = Int.random(in: 1000..<9999)
                let phone = "0101010" + String(randomInt)
                onClickNext(step: .agree, params: ["id": snsID, "pwd": snsID, "type": snsType, "phone" : phone, "code" : "111111"])
            } else {
                onClickNext(step: .auth, params: ["id": snsID, "pwd": snsID, "type": snsType])
            }
        } else {
            onClickNext(step: .first, params:["type": snsType])
        }
    }
    
    override func onBackProcess(_ viewController: UIViewController) {
        ConfirmDialog.show(self, title: "signup_cancel_alert_title".localized, message: "signup_cancel_alert_content"._localized, showCancelBtn: true) { [weak self]() -> Void in
            self?.popToStartVC()
        }
    }
    
    
    private func onRecvDuplicated() {
        AlertDialog.show(self, title: "signup_duplicated_id_title"._localized, message: "signup_duplicated_id_detail"._localized)
    }
}

//
// MARK: - Action
//
extension SignupVC: BaseAction {
}


extension SignupVC: SignupNextDelegate {
    func onClickNext(step: SingupStep, params: [String: Any]) {
        if let oldVC = currentSignupPageVC {
            oldVC.view.removeFromSuperview()
            oldVC.removeFromParent()
            currentSignupPageVC = nil
        }
        
        switch step {
        case .first:
            let vc = SignupPage1VC(nibName: "vc_signup_page1", bundle: nil)
            vc.nextDelegate = self
            currentSignupPageVC = vc
            vwContent.addSubView(subView: vc.view!, isFull: true)
            self.addChild(vc)
            vwSignupProgress.progress = 0.33
        case .auth:
            let vc = SignupPage2VC(nibName: "vc_signup_page2", bundle: nil)
            vc.nextDelegate = self
            vc.params = params
            vwContent.addSubView(subView: vc.view!, isFull: true)
            
            self.addChild(vc)
            currentSignupPageVC = vc
            vwSignupProgress.progress = 0.66
        case .agree:
            let vc = AgreePageVC(nibName: "vc_agree_page", bundle: nil)
            vc.nextDelegate = self
            vc.params = params
            vwContent.addSubView(subView: vc.view!, isFull: true)
            
            self.addChild(vc)
            currentSignupPageVC = vc
            vwSignupProgress.progress = 1
        case .complete:
            let vc = SignupCompleteVC(nibName: "vc_signup_complete", bundle: nil)
            self.pushVC(vc, animated: true, params:params)
        }
    }
}
