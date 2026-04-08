import SVProgressHUD
import SwiftyJSON
import Toast_Swift
import UIKit

class FindPwdVC: BaseVC {
    @IBOutlet weak var tfID: UITextField!
    @IBOutlet weak var tfPhonenumber: UITextField!
    @IBOutlet weak var tfCertification: UITextField!
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBOutlet weak var phoneEditRightView: UIView!
    @IBOutlet weak var lblDownTime: CountDownTimeLabel!
    @IBOutlet weak var groupResend: UIView!
    
    var authStatus:UNAuthorizationStatus = .notDetermined
    var authCode:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userID = params["userID"] as? String {
            tfID.text = userID
        }

//        initLang()
    }
    
    private func initLang() {
//        lblPwd.text = getLangString("pwd_reset_title")
//        lblPwdDesc.text = getLangString("pwd_reset_desc1")
//        lblBackToFirst.text = getLangString("pwd_reset_desc2")
//        tfEmail.placeholder = getLangString("signup_email_hint")
//        btnReset.setTitle(getLangString("pwd_reset"), for: .normal)
//        btnLogin.setUnderlineTitle(getLangString("guide_btn_login"), font: AppFont.robotoRegular(11), color: AppColor.black, for: .normal)
    }
    
    override func hideKeyboard() {
        tfID.resignFirstResponder()
        tfPhonenumber.resignFirstResponder()
        tfCertification.resignFirstResponder()
    }
    
    private func changeAuthStatus(auth: UNAuthorizationStatus) {
        authStatus = auth
        switch auth {
        case .notDetermined:
            lblDownTime.stopTimer()
            lblDownTime.isHidden = true
            groupResend.isHidden = true
            btnConfirm.isEnabled = false
        case .authorized:
            lblDownTime.stopTimer()
            lblDownTime.isHidden = true
            groupResend.isHidden = true
        case .provisional:
            groupResend.isHidden = false
            lblDownTime.startCountDownTimer()
            lblDownTime.isHidden = false
            btnConfirm.isEnabled = true
        default:
            break
        }
    }
    
    
    private func showNonRegisterPhone() {
        AlertDialog.show(self, title: "no_phone_title"._localized, message: "no_phone_desc"._localized)
    }
    
    private func onResetSuccess(userID: String, phone: String, code: String) {
        self.pushVC(PwdChangeVC(nibName: "vc_pwd_change", bundle: nil), animated: true, params: ["userID":userID])
    }
    
    func findPwd() {
        guard let loginID = tfID.text, !loginID.isEmpty else {
            self.view.showToast("empty_id_toast"._localized)
            return
        }
        
        guard let phoneNumber = tfPhonenumber.text, !phoneNumber.isEmpty else {
            self.view.showToast("empty_phone_toast"._localized)
            return
        }
        
        guard let code = tfCertification.text, !code.isEmpty else {
            self.view.showToast("empty_cert_code_toast"._localized)
            return
        }
        
        if code == self.authCode {
            changeAuthStatus(auth: .authorized)
            onResetSuccess(userID: loginID, phone: phoneNumber, code: code)
        } else {
            self.view.showToast("mismatch_cert_code_toast"._localized)
        }
    }
    
    //
    // MARK: - Action
    //
    
    @IBAction func onFindPwd(_ sender: Any) {
        hideKeyboard()
        
        guard let textID = tfID.text, !textID.isEmpty else {
            self.view.showToast("signup_id_empty_alert"._localized)
            return
        }
        
        findPwd()
    }
    
    @IBAction func onAuthReqest(_ sender: Any) {
        hideKeyboard()
        
        guard let textID = tfID.text, !textID.isEmpty else {
            self.view.showToast("signup_id_empty_alert"._localized)
            return
        }
        
        guard let phoneNumber = tfPhonenumber.text, !phoneNumber.isEmpty else {
            self.view.showToast("empty_phone_toast"._localized)
            return
        }
        
        authRequest(loginId: textID, phoneNumber: phoneNumber)
    }
    
    @IBAction func onClickClearPhoneEdit(_ sender: Any) {
        tfPhonenumber.text = nil
        phoneEditRightView.isHidden = true
        changeAuthStatus(auth: .notDetermined)
    }
    
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        if sender == tfID {
            changeAuthStatus(auth: .notDetermined)
        }
        else if sender == tfPhonenumber {
            changeAuthStatus(auth: .notDetermined)
            guard let phone = tfPhonenumber.text, !phone.isEmpty else {
                phoneEditRightView.isHidden = true
                return
            }
            
            phoneEditRightView.isHidden = false
        } else if sender == tfCertification {
            guard let code = tfCertification.text, !code.isEmpty else {
                btnConfirm.isEnabled = false
                return
            }
            
            if authStatus == .provisional {
                btnConfirm.isEnabled = true
            }
        }
    }
    
}

//
// MARK: - UITextFieldDelegate
//
extension FindPwdVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLen = (textField.text?.count ?? 0) - range.length + string.count

        if textField == tfPhonenumber, newLen > 11 {
            return false
        }

        return true
    }
}

//
// MARK: - RestApi
//
extension FindPwdVC: BaseRestApi {
    func authRequest(loginId:String, phoneNumber: String) {
        LoadingDialog.show()
        Rest.request_code_for_find(loginId:loginId, phoneNumber: phoneNumber, success: { [weak self](result) -> Void in
            LoadingDialog.dismiss()
            self?.authCode = result?.code
            self?.changeAuthStatus(auth: .provisional)
        }) { [weak self](code, err) -> Void in
            LoadingDialog.dismiss()
            if code == ResponseResultCode.ERROR_USER_NO_EXIST.rawValue {
                self?.showNonRegisterPhone()
            } else {
                self?.view.showToast(err)
            }
            
            self?.changeAuthStatus(auth: .notDetermined)
        }
    }
}

extension FindPwdVC: CountDownTimeIsUp {
    func onTimeIsUp(sender: CountDownTimeLabel) {
        sender.isHidden = true
        changeAuthStatus(auth: .notDetermined)
    }
}
