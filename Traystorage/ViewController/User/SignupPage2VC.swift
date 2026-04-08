import SVProgressHUD
import SwiftyJSON
import Toast_Swift
import UIKit
// import Material

// signup 2nd screen
class SignupPage2VC: BaseVC {
    @IBOutlet var lblAuthMedia: UILabel!
    @IBOutlet var lblSent: UILabel!
    @IBOutlet var lblInput: UILabel!
    @IBOutlet var groupResend: UIView!
    
    @IBOutlet var phoneEditRightView: UIView!
    @IBOutlet var btnConfirmCode: UIButton!
    
    @IBOutlet var tfPhoneNumber: UITextField!
    @IBOutlet var tfCertificationNumber: UITextField!
    
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var lblDownTime: CountDownTimeLabel!
    
    open var authType = AuthType.phone
    open var authMedia = ""
    
    var authStatus: UNAuthorizationStatus = .notDetermined
    weak var nextDelegate: SignupNextDelegate?
    
    var authData: [String: String] = [:] // phone, code
    
    var authCode: String?
    
    var isPhoneAuth = false
    var isConfirm = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func initVC() {
        if authType == AuthType.phone {
            lblAuthMedia.text = String(format: "+86 %@", authMedia)
        } else {
            lblAuthMedia.text = authMedia
        }
    }
    
    override func hideKeyboard() {
        tfPhoneNumber.resignFirstResponder()
        tfCertificationNumber.resignFirstResponder()
    }
    
    private func changedAuthStatus(auth: UNAuthorizationStatus) {
        authStatus = auth
        switch authStatus {
        case .notDetermined:
            lblDownTime.stopTimer()
            groupResend.isHidden = true
            btnConfirmCode.isHidden = true
            btnNext.isEnabled = false
        case .authorized:
            lblDownTime.stopTimer()
            btnConfirmCode.isHidden = true
            groupResend.isHidden = true
            btnNext.isEnabled = true
        case .provisional:
            lblDownTime.startCountDownTimer()
            groupResend.isHidden = false
            btnConfirmCode.isHidden = false
            showToast("signup_phone_verify_success"._localized)
        case .denied:
            lblDownTime.stopTimer()
            groupResend.isHidden = true
            btnConfirmCode.isHidden = true
            btnNext.isEnabled = false
        default:
            btnNext.isEnabled = false
        }
    }
    
    override func onBackProcess(_ viewController: UIViewController) {
        showConfirm(title: "signup_cancel_alert_title".localized, message: "signup_cancel_alert_content"._localized, showCancelBtn: true) { [weak self] () -> Void in
            self?.popToStartVC()
        }
    }
        
    private func onPhoneAuthDuplicated() {
        showAlert(title: "signup_duplicated_phone"._localized, message: "")
    }
}

//

// MARK: - Action

//
extension SignupPage2VC: BaseAction {
    @IBAction func onClickPhoneAuth(_ sender: Any) {
        hideKeyboard()
        if let phoneNumber = tfPhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines), !phoneNumber.isEmpty {
            sendPhoneAuth(phoneNumber)
        } else {
            showToast("empty_phone_toast"._localized)
        }
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        hideKeyboard()

        let phone = authData["phone"]!
        let code = authData["code"]!
        goNext(phone: phone, code: code)
    }
    
    @IBAction func onClickConfirmCertNum(_ sender: Any) {
        hideKeyboard()
        guard let code = tfCertificationNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines), !code.isEmpty else {
            return
        }

        verifyCode(code)
    }
    
    @IBAction func onClickClearPhoneEdit(_ sender: Any) {
        tfPhoneNumber.text = nil
        phoneEditRightView.isHidden = true
        changedAuthStatus(auth: .notDetermined)
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if sender == tfPhoneNumber {
            changedAuthStatus(auth: .notDetermined)
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
extension SignupPage2VC: UITextFieldDelegate {
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
extension SignupPage2VC: BaseNavigation {
    private func goNext(phone: String, code: String) {
        var params: [String: Any] = [:]
        for (k, v) in self.params {
            params[k] = v
        }
        
        params["phone"] = phone
        params["code"] = code
        
        if let nextDelegate = self.nextDelegate {
            nextDelegate.onClickNext(step: .agree, params: params)
        }
    }
}

//

// MARK: - RestApi

//
extension SignupPage2VC: BaseRestApi {
    private func sendPhoneAuth(_ phone: String) {
        LoadingDialog.show()
        if authType == AuthType.phone {
            Rest.request_code_for_signup(phoneNumber: phone, success: {
                [weak self] result in
                LoadingDialog.dismiss()
                self?.authCode = result!.code
                self?.changedAuthStatus(auth: .provisional)
            }) { [weak self] code, msg in
                LoadingDialog.dismiss()
                if code == 206 {
                    self?.onPhoneAuthDuplicated()
                } else {
                    self?.showToast(msg)
                }
            }
        } else {}
    }
    
    private func verifyCode(_ code: String) {
        guard let phone = tfPhoneNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines), !phone.isEmpty else {
            return
        }
        
        if gReview {
            authData["phone"] = phone
            authData["code"] = code
            changedAuthStatus(auth: .authorized)
        } else {
            if code == authCode {
                authData["phone"] = phone
                authData["code"] = code
                changedAuthStatus(auth: .authorized)
            } else {
                showToast(localized: "mismatch_cert_code_toast")
            }
        }
    }
}
