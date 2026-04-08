import SVProgressHUD
import SwiftyJSON
import Toast_Swift
import UIKit
//import Material

// signup 2nd screen
class SignupAuthCodeVC: BaseVC {
    @IBOutlet weak var lblAuthMedia: UILabel!
    @IBOutlet weak var lblSent: UILabel!
    @IBOutlet weak var lblInput: UILabel!
    @IBOutlet weak var groupResend: UIView!
    
    @IBOutlet weak var phoneEditRightView: UIView!
    @IBOutlet weak var btnConfirmCode: UIButton!
    
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfCertificationNumber: UITextField!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblDownTime: CountDownTimeLabel!
    
    open var authType = AuthType.phone
    open var authMedia = ""
    
    var authStatus:UNAuthorizationStatus = .notDetermined
    
    
    var authData: [String: String] = [:] // phone, code
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func initVC() {
        if authType == AuthType.phone {
            lblAuthMedia.text = String.init(format: "+86 %@", authMedia)
        } else {
            lblAuthMedia.text = authMedia
        }
    }
    
    override func hideKeyboard() {
        tfPhoneNumber.resignFirstResponder()
        tfCertificationNumber.resignFirstResponder()
    }
    
    private func changedAuthStatus(auth: UNAuthorizationStatus) {
        self.authStatus = auth
        switch authStatus {
        case .authorized:
            lblDownTime.stopTimer()
            btnConfirmCode.isHidden = true
            groupResend.isHidden = true
            btnNext.isEnabled = true
            break
        case .provisional:
            lblDownTime.startCountDownTimer()
            groupResend.isHidden = false
            btnConfirmCode.isHidden = false
            self.view.showToast("signup_phone_verify_success"._localized)
            break
        case .denied:
            btnConfirmCode.isHidden = true
        default:
            btnNext.isEnabled = false
            break
        }
    }
    
    override func onBackProcess(_ viewController: UIViewController) {
        ConfirmDialog.show(self, title: "signup_cancel_alert_title".localized, message: "signup_cancel_alert_content"._localized, showCancelBtn: true) { [weak self]() -> Void in
            self?.popToStartVC()
        }
    }
        
    private func onPhoneAuthDuplicated() {
        AlertDialog.show(self, title:"signup_duplicated_phone"._localized, message: "")
    }
}

//
// MARK: - Action
//
extension SignupAuthCodeVC: BaseAction {
    @IBAction func onClickPhoneAuth(_ sender: Any) {
        hideKeyboard()
        if let phoneNumber = tfPhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines), !phoneNumber.isEmpty {
            sendPhoneAuth(phoneNumber)
        } else {
            self.view.showToast("empty_phone_toast"._localized)
        }
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        hideKeyboard()

        let phone = authData["phone"]!
        let code = authData["code"]!
        self.goNext(phone: phone, code: code)
    }
    
    @IBAction func onClickConfirmCertNum(_ sender: Any) {
        guard let code = tfCertificationNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines), !code.isEmpty else {
            return
        }

        verifyCode(code)
    }
    
    @IBAction func onClickClearPhoneEdit(_ sender: Any) {
        tfPhoneNumber.text = nil
        phoneEditRightView.isHidden = true
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if sender == tfPhoneNumber {
            guard let phoneNumber = tfPhoneNumber.text, !phoneNumber.isEmpty else {
                phoneEditRightView.isHidden = true
                return
            }
            
            phoneEditRightView.isHidden = false
        } else if sender == tfCertificationNumber {
            guard let code = tfCertificationNumber.text, !code.isEmpty else {
                btnConfirmCode.isHidden = true
                return
            }
            
            if authStatus == .provisional {
                btnConfirmCode.isHidden = false
            }
        }
    }
}

//
// MARK: - UITextFieldDelegate
//
extension SignupAuthCodeVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLen = (textField.text?.count ?? 0) - range.length + string.count
        if textField == tfPhoneNumber, newLen > 11 {
            return false
        }
        if textField == tfCertificationNumber, newLen > 8 {
            return false
        }

        return true
    }
}

//
// MARK: - Navigation
//
extension SignupAuthCodeVC: BaseNavigation {
    private func goNext(phone: String, code: String) {

    }
}

//
// MARK: - RestApi
//
extension SignupAuthCodeVC: BaseRestApi {
    private func sendPhoneAuth(_ phone: String) {
        LoadingDialog.show()
        if authType == AuthType.phone {
            Rest.request_code_for_signup(phoneNumber: phone, success: {
                [weak self](result) in
                LoadingDialog.dismiss()
                self?.changedAuthStatus(auth: .provisional)
            }) { [weak self] (code, msg) in
                LoadingDialog.dismiss()
                if code == 206 {
                    self?.onPhoneAuthDuplicated()
                } else {
                    self?.view.showToast(msg)
                }
            }
        } else {
            Rest.sendCertKey(email: authMedia, success: { (result) in
                LoadingDialog.dismiss()

                let messageEmail = getLangString("dialog_auth_code_email_sent") + "\n\n\n" + self.authMedia

                ConfirmDialog.show(self, title:getLangString("send_success"), message: messageEmail, showCancelBtn : false){

                }
            }, failure: { _, msg in
                LoadingDialog.dismiss()
                self.view.showToast(msg)
            })
        }
    }
    
    private func verifyCode(_ code: String) {
        guard let phone = tfPhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines), !phone.isEmpty else {
            return
        }

        LoadingDialog.show()
        
        if authType == AuthType.phone {
            Rest.verifyPhoneCode(phone: phone, code: code, isContinue: 1, success: { [weak self](result) in
                LoadingDialog.dismiss()
                let phoneVerify = result as! ModelBase
                self?.authData["phone"] = phone
                self?.authData["code"] = phoneVerify.code.description
                self?.changedAuthStatus(auth: .authorized)
            }) { [weak self](_, msg) in
                LoadingDialog.dismiss()
//                self?.changedAuthStatus(auth: .denied)
                self?.view.showToast(msg)
            }
        } else {
//            Rest.verifyCertKey(email: authMedia, certKey: certKey, success: { (result) in
//                LoadingDialog.dismiss()
//                self.goNext()
//            }, failure: { _, msg in
//                LoadingDialog.dismiss()
//                self.view.showToast(msg)
//            })
        }
    }
}
