import SVProgressHUD
import SwiftyJSON
import Toast_Swift
import UIKit

class CheckIdVC: BaseVC {
    
    @IBOutlet weak var lblLoginID: UILabel!
    
    var userLoginID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        userLoginID = params["userID"] as! String
        let signupType = params["type"] as! Int
        switch signupType {
        case 0:
            lblLoginID.text = userLoginID
            break
        case 1:
            lblLoginID.text = "google signuped"
            break
        case 2:
            lblLoginID.text = "naver signuped"
            break
        case 3:
            lblLoginID.text = "facebook signuped"
            break
        case 4:
            lblLoginID.text = "kakaos signuped"
            break
        default:
            break
        }
    }
    
    //
    // MARK: - Action
    //
    
    @IBAction func onFindPassword(_ sender: Any) {
        self.pushVC(FindPwdVC(nibName: "vc_findpwd", bundle: nil), animated: true, params:["userID" : userLoginID])
    }
    
    @IBAction func onLogin(_ sender: Any) {
        
        if let nv = self.navigationController {
            let vcs = nv.viewControllers
            for vc in vcs {
                if vc is LoginVC {
                    let logVC = vc as! LoginVC
                    logVC.resetLoginInputInformation()
                    logVC.setLoginID(userID: userLoginID)
                    nv.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
}
