import SVProgressHUD
import UIKit

class PwdChangeVC: BaseVC {
    @IBOutlet weak var lblNewPwd: UILabel!
    @IBOutlet weak var tfNewPwd: UITextField!
    @IBOutlet weak var lblConfirmPwd: UILabel!
    @IBOutlet weak var tfConfirmPwd: UITextField!
    @IBOutlet weak var btnConfirm: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func hideKeyboard() {
        tfNewPwd.resignFirstResponder()
        tfConfirmPwd.resignFirstResponder()
    }
    
    private func onPasswordChanged() {
        ConfirmDialog.show2(self, title: "pwd_change_notify_title"._localized,
                            message: "pwd_change_notify_login"._localized,
                            showCancelBtn: false) {[weak self] in
            self?.popPassword()
        }
    }
    
    private func popPassword() {
        guard let vcs = self.navigationController?.viewControllers.reversed() else {
            return
        }
        
        for vc in vcs {
            if vc is SettingVC {
                self.navigationController?.popToViewController(vc, animated: true)
                return
            }
        }
        
        popToLogVC()
    }
    
    private func checkValidInput() {
        guard let pass = tfNewPwd.text, let confirmPass = tfConfirmPwd.text, pass == confirmPass else {
            btnConfirm.isEnabled = false
            return
        }
        
        btnConfirm.isEnabled = true
    }
    
    //
    // MARK: Action
    //
    
    @IBAction func onClickConfirm(_ sender: Any) {
        hideKeyboard()
        guard let pass = tfNewPwd.text, Validations.isValid(password: pass) else {
            self.showToast(localized: "password_invalid")
            return
        }
        guard let confirmPass = tfConfirmPwd.text, pass == confirmPass else {
            self.view.showToast("password_mismatch_confirm"._localized)
            return
        }
        
        let loginID = params["userID"] as! String
        changePwd(userID: loginID, pwd: pass)
    }
    
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        checkValidInput()
    }
}

//
// MARK: - UITextFieldDelegate
//
extension PwdChangeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case tfNewPwd:
                tfConfirmPwd.becomeFirstResponder()
                break
            case tfConfirmPwd:
                if btnConfirm.isEnabled {
                    onClickConfirm(0)
                }
                textField.resignFirstResponder()
                break
            default:
                textField.resignFirstResponder()
                break
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLen = (textField.text?.count ?? 0) - range.length + string.count

        if newLen > 20 {
            return false
        }
        return true
    }
}


//
// MARK: - RestApi
//
extension PwdChangeVC: BaseRestApi {
    func changePwd(userID: String, pwd: String) {
        LoadingDialog.show()
        Rest.changePwd(loginID: userID, password: pwd, success: { [weak self] (result) -> Void in
            LoadingDialog.dismiss()
            if let user = Rest.user {
                user.pwd = pwd
                Local.setUser(user)
            }
            
            self?.onPasswordChanged()
        }) { [weak self] (_, err) -> Void in
            LoadingDialog.dismiss()
            self?.view.showToast(err)
        }
    }
}
