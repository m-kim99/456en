import SVProgressHUD
import SwiftyJSON
import Toast_Swift
import UIKit
//import Material

class SignupPage1VC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnTabPhone: UIButton!
    @IBOutlet weak var btnTabEmail: UIButton!
    
    @IBOutlet weak var tfID: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfPasswordConfirm: UITextField!
    
    @IBOutlet weak var vwInput: UIView!
    @IBOutlet weak var vwPhoneInput: UIView!
    @IBOutlet weak var lblError: UILabel!
    
    @IBOutlet weak var lblMember: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnDuplicateCheck: UIButton!
    
    private var curTab = AuthType.phone
    
    private var isCheckedID = false
    
    weak var nextDelegate: SignupNextDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tfPassword.font = .systemFont(ofSize: 11)
    }
    
    private func changeTab(_ tab: AuthType) {
//        curTab = tab
//
////        vwPhoneLine.backgroundColor = (tab == AuthType.phone) ? AppColor.black : AppColor.signup_tab_line
////        vwEmailLine.backgroundColor = (tab == AuthType.email) ? AppColor.black : AppColor.signup_tab_line
////
////        btnTabPhone.setTitleColor(tab == AuthType.phone ? AppColor.black : AppColor.gray, for: .normal)
////        btnTabEmail.setTitleColor(tab == AuthType.email ? AppColor.black : AppColor.gray, for: .normal)
//
//        vwPhoneInput.isHidden = !(tab == AuthType.phone)
//        tfEmail.isHidden = !(tab == AuthType.email)
//
//        hideError()
//        enableNext(false)
//        tfPhone.text = ""
//        tfEmail.text = ""
    }
    
    private func enableNext(_ enable: Bool) {
        btnNext.isEnabled = enable
    }
    

    
    private func hideError() {
//        vwInput.borderColor = AppColor.gray
//        lblError.isHidden = true
    }
    
    override func hideKeyboard() {
        tfID.resignFirstResponder()
        tfPassword.resignFirstResponder()
        tfPasswordConfirm.resignFirstResponder()
    }
        
    private func showDialog(_ type: AuthType) {
//        let messagePhone = getLangString("dialog_auth_code_phone_sent") + "\n\n\n" + tfPhone.text!
//        
//        let messageEmail = getLangString("dialog_auth_code_email_sent") + "\n\n\n" + tfEmail.text!
//        
//        ConfirmDialog.show(self, title:getLangString("send_success"), message: curTab == AuthType.phone ? messagePhone : messageEmail, showCancelBtn : false){
//            self.goNext()
//        }
    }
    
    private func checkValidInput() {
        guard let userID = tfID.text?.trimmingCharacters(in: .whitespacesAndNewlines), !userID.isEmpty else {
            enableNext(false)
            return
        }
        
        guard let pass = tfPassword.text, !pass.isEmpty, let passConfirm = tfPasswordConfirm.text, pass == passConfirm else {
            enableNext(false)
            return
        }
        
        enableNext(true)
    }
    
    private func onRecvDuplicated() {
        showAlert(title: "signup_duplicated_id_title"._localized, message: "signup_duplicated_id_detail"._localized)
    }
    
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if sender == tfID {
            if let userID = tfID.text?.trimmingCharacters(in: .whitespacesAndNewlines), userID.count > 0 {
                btnDuplicateCheck.isHidden = false
            } else {
                btnDuplicateCheck.isHidden = true
            }
            
            isCheckedID = false
        }
        
        checkValidInput()
    }
}

//
// MARK: - Action
//
extension SignupPage1VC: BaseAction {
    @IBAction func onClickBg(_ sender: Any) {
        hideKeyboard()
    }
    
    @IBAction func onTabPhone(_ sender: Any) {
        changeTab(AuthType.phone)
    }
    
    @IBAction func onTabEmail(_ sender: Any) {
        changeTab(AuthType.email)
    }
    
    @IBAction func onNext(_ sender: Any) {
        hideKeyboard()
        goNext()
    }
    
    @IBAction func onClickDuplicate(_ sender: Any) {
        hideKeyboard()
        guard let newID = tfID.text?.trimmingCharacters(in: .whitespacesAndNewlines), !newID.isEmpty else {
            self.showToast(localized: "signup_id_empty_alert")
            return
        }
        
        if newID.count < 4 {
            self.showToast(localized: "signup_id_less4")
            return
        }
        
        sendCheckID(loginID: newID)
    }
}

//
// MARK: - Navigation
//
extension SignupPage1VC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLen = (textField.text?.count ?? 0) - range.length + string.count

        if textField == tfID, newLen > 20 {
            return false
        }
        if textField == tfPassword, newLen > 20 {
            return false
        }
        
        if textField == tfPasswordConfirm, newLen > 20 {
            return false
        }

        return true
    }
}

//
// MARK: - Navigation
//
extension SignupPage1VC: BaseNavigation {
    private func goNext() {
        guard let userID = tfID.text?.trimmingCharacters(in: .whitespacesAndNewlines), !userID.isEmpty else {
            return
        }
        
        guard let pass = tfPassword.text, !pass.isEmpty, let passConfirm = tfPasswordConfirm.text, pass == passConfirm else {
            self.showAlert(title: "password_mismatch_confirm"._localized)
            return
        }
        
        guard isCheckedID else {
            self.showToast(localized: "signup_check_id_req")
            return
        }
        
        guard Validations.isValid(password: pass) else {
            self.showToast(localized: "password_invalid")
            return
        }
        
        if let nextDelegate = self.nextDelegate {
            if gReview {
                let randomInt = Int.random(in: 1000..<9999)
                let phone = "0101010" + String(randomInt)
                nextDelegate.onClickNext(step: .agree, params: ["id": userID, "pwd": pass, "phone" : phone, "code" : "111111"])
            } else {
                nextDelegate.onClickNext(step: .auth, params: ["id": userID, "pwd": pass])
            }
            
        }
    }
}

//
// MARK: - RestApi
//
extension SignupPage1VC: BaseRestApi {
    private func sendCheckID(loginID: String) {
        LoadingDialog.show()
        Rest.check_login_id(loginID: loginID, success: {[weak self] (result) in
            LoadingDialog.dismiss()
            self?.showToast(localized: "signup_id_unique")
            self?.isCheckedID = true
        }) {[weak self] (code, msg) in
            LoadingDialog.dismiss()
            if code == 203 { // duplicated
                self?.onRecvDuplicated()
            } else {
                self?.showToast(msg)
            }
        }
    }
}
