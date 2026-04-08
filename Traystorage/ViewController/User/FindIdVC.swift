import SVProgressHUD
import SwiftyJSON
import Toast_Swift
import UIKit

enum IDRequest: Int {
    case findID = 0
    case changePassword = 1
    case withDrawal = 2
    case withDrawalCancel = 3
}

class FindIdVC: BaseVC {
    @IBOutlet weak var tfPhonenumber: UITextField!
    @IBOutlet weak var tfCertification: UITextField!
    @IBOutlet weak var lblDownTime: CountDownTimeLabel!
    
    
    @IBOutlet weak var phoneEditRightView: UIView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var groupResend: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    var authStatus:UNAuthorizationStatus = .notDetermined
    var authCode: String?
    var findId: String?
    var signupType: Int?

    var isPhoneVerify = false
    var findIDRequest: IDRequest = .findID
    var loginId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblDownTime.timeIsUpDelegate = self
//        initLang()
//        initVC()
        
        if findIDRequest == .withDrawal {
            lblDesc.text = "phone_verify_withdraw_desc"._localized
        }
        
        if findIDRequest == .withDrawal || findIDRequest == .changePassword {
            lblTitle.text = "phone_verify_title"._localized
            loginId = Rest.user!.loginId
        }
    }
    
    private func initLang() {
//        lblPwd.text = getLangString("pwd_reset_title")
//        lblPwdDesc.text = getLangString("pwd_reset_desc1")
//        lblBackToFirst.text = getLangString("pwd_reset_desc2")
//        tfEmail.placeholder = getLangString("signup_email_hint")
    }
    
    override func hideKeyboard() {
        tfPhonenumber.resignFirstResponder()
        tfCertification.resignFirstResponder()
    }
    
    private func onResetSuccess(userID: String) {
        switch findIDRequest {
        case .findID:
            pushVC(CheckIdVC(nibName: "vc_check_id", bundle: nil), animated: true, params: ["userID": userID, "type":signupType])
            break
        case .changePassword:
            let user = Rest.user!

            pushVC(PwdChangeVC(nibName: "vc_pwd_change", bundle: nil), animated: true, params: ["userID" : user.loginId])
            break
        case .withDrawal:
            showConfirm(title: "withdrawal_confirm_title"._localized, message: "", showCancelBtn: true) {
                [weak self] in
                self?.requestExit()
            }
            
        case .withDrawalCancel:
            cancelExit(userID: userID)
            
            break
        }
    }
    
    private func showNonRegisterPhone() {
        AlertDialog.show(self, title: "no_phone_title"._localized, message: "no_phone_desc"._localized)
    }
    
    private func showAlert(title: String, message: String) {
        AlertDialog.show(self, title: title, message: message)
    }
    
    private func changeAuthStatus(auth: UNAuthorizationStatus) {
        authStatus = auth
        switch auth {
        case .notDetermined:
            lblDownTime.stopTimer()
            groupResend.isHidden = true
            btnConfirm.isEnabled = false
        case .denied:
            groupResend.isHidden = true
            btnConfirm.isEnabled = false
        case .authorized:
            lblDownTime.stopTimer()
            lblDownTime.isHidden = true
            groupResend.isHidden = true
            break
        case .provisional:
            groupResend.isHidden = false
            lblDownTime.startCountDownTimer()
            lblDownTime.isHidden = false
            break
        default:
            break
        }
    }
    
    func openMainVC() {
        let mainVC = UIStoryboard(name: "vc_main", bundle: nil).instantiateInitialViewController()
        self.pushVC(mainVC as! BaseVC, animated: true)
    }
    
    private func onLoginSuccess(user: ModelUser!) {
        Rest.user = user
        Local.setUser(Rest.user)

        let ud = UserDefaults.standard
        ud.removeObject(forKey: Local.PREFS_APP_AUTO_LOGIN.rawValue)
        ud.synchronize()
        openMainVC()
    }
    
    //
    // MARK: - Action
    //
    
    @IBAction func onClickConfirm(_ sender: Any) {
        hideKeyboard()
        doFindId()
    }
    
    @IBAction func textDidChanged(_ sender: UITextField) {
        if sender == tfPhonenumber {
            changeAuthStatus(auth: .notDetermined)
            guard let phone = tfPhonenumber.text, !phone.isEmpty else {
                phoneEditRightView.isHidden = true
                btnConfirm.isEnabled = false
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
    @IBAction func onClickAuthRequest(_ sender: Any) {
        hideKeyboard()
        guard let phoneNumber = tfPhonenumber.text, !phoneNumber.isEmpty else {
            self.view.showToast("empty_phone_toast"._localized)
            return
        }
  
        authRequest(phoneNumber: phoneNumber)
    }
    
    @IBAction func onClickClearPhoneEdit(_ sender: Any) {
        tfPhonenumber.text = nil
        phoneEditRightView.isHidden = true
        changeAuthStatus(auth: .notDetermined)
    }
}

//
// MARK: - UITextFieldDelegate
//
extension FindIdVC: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
////        tfEmail.resignFirstResponder()
//        doFindId()
//        return true
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLen = (textField.text?.count ?? 0) - range.length + string.count

        if textField == tfPhonenumber, newLen > 11 {
            return false
        }
        if textField == tfCertification, newLen > 10 {
            return false
        }

        return true
    }
}

//
// MARK: - RestApi
//
extension FindIdVC: BaseRestApi {
    func doFindId() {
        guard let code = tfCertification.text?.trimmingCharacters(in: .whitespacesAndNewlines), !code.isEmpty else {
            return
        }
        
        if authCode == code, let foundId = findId {
            changeAuthStatus(auth: .authorized)
            onResetSuccess(userID: foundId)
        } else {
            self.view.showToast("mismatch_cert_code_toast"._localized)
        }
    }
    
    func authRequest(phoneNumber: String) {
        LoadingDialog.show()
        Rest.request_code_for_find(loginId:loginId ?? "", phoneNumber: phoneNumber, success: { [weak self](result) -> Void in
            LoadingDialog.dismiss()
            let modelCode = result as! ModelBase
            self?.authCode = modelCode.code
            self?.findId = modelCode.loginId
            self?.signupType = modelCode.signup_type
            self?.changeAuthStatus(auth: .provisional)
        }) { [weak self](code, err) -> Void in
            LoadingDialog.dismiss()
            if code == 202 {
                self?.showNonRegisterPhone()
            } else {
                self?.view.showToast(err)
            }
        }
    }
    
    func requestExit() {
        LoadingDialog.show()
        Rest.requestExit(success: { [weak self](result) -> Void in
            LoadingDialog.dismiss()
            
            self?.pushVC(WithdrawalResultVC(nibName: "vc_withdrawal_result", bundle: nil), animated: true, params: ["date" : result?.loginId])
        }) { [weak self](code, err) -> Void in
            LoadingDialog.dismiss()
            if code == 202 {
                self?.showNonRegisterPhone()
            } else {
                self?.view.showToast(err)
            }
        }
    }
    
    func cancelExit(userID: String) {
        LoadingDialog.show()
        Rest.cancelExit(userID: userID, success: { [weak self](result) -> Void in
            LoadingDialog.dismiss()
            
            let user = result! as! ModelUser
            self?.onLoginSuccess(user: user)
        }) { [weak self](code, err) -> Void in
            LoadingDialog.dismiss()
            if code == 202 {
                self?.showNonRegisterPhone()
            } else {
                self?.view.showToast(err)
            }
        }
    }
}

extension FindIdVC: CountDownTimeIsUp {
    func onTimeIsUp(sender: CountDownTimeLabel) {
        sender.isHidden = true
        changeAuthStatus(auth: .denied)
    }
}
