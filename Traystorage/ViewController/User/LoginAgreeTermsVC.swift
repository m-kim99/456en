import SVProgressHUD
import SwiftyJSON
import Toast_Swift
import UIKit

class LoginAgreeTermsVC: BaseVC {
    @IBOutlet weak var vwContent: UIView!
    var isAllAgree = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = AgreePageVC(nibName: "vc_agree_page", bundle: nil)
        vc.nextDelegate = self
        vc.agreeType = .login
        vwContent.addSubView(subView: vc.view!, isFull: true)
        self.addChild(vc)
    }
    
    func openMainVC() {
        let mainVC = UIStoryboard(name: "vc_main", bundle: nil).instantiateInitialViewController()
        pushVC(mainVC! as! BaseVC, animated: true)
    }
}

//
// MARK: - Action
//
extension LoginAgreeTermsVC: SignupNextDelegate {
    func onClickNext(step: SingupStep, params: [String : Any]) {
        agreeTerms()
    }
}

//
// MARK: - RestApi
//
extension LoginAgreeTermsVC: BaseRestApi {
    func agreeTerms() {
        LoadingDialog.show()
        Rest.agreementTerms(success: { [weak self] (result) -> Void in
            LoadingDialog.dismiss()
            self?.openMainVC()
        }) { [weak self](code, err) -> Void in
            LoadingDialog.dismiss()
            self?.showToast(err)
        }
    }
}
