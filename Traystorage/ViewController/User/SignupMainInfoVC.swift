import SVProgressHUD
import SwiftyJSON
import Toast_Swift
import UIKit

class SignupMainInfoVC: BaseVC {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfBirthday: UITextField!
    @IBOutlet weak var tfGender: UITextField!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    private var isTfBirthdaySelected = false
    
    open var authType = AuthType.phone
    open var authMedia = ""
    open var authCode = ""
    open var authPwd = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLang()
        initVC()
    }
    
    private func initLang() {
        lblTitle.text = getLangString("signup_main_info")
        lblDesc.text = getLangString("signup_main_info_desc")
        
        tfName.placeholder = getLangString("signup_name_hint")
        tfBirthday.placeholder = getLangString("signup_birthday_hint")
        tfGender.placeholder = getLangString("signup_gender_hint")
        
        btnNext.setTitle(getLangString("signup_next"), for: .normal)
        
        lblMember.text = getLangString("signup_member_1")
        btnLogin.setUnderlineTitle(getLangString("guide_btn_login"), font: AppFont.robotoRegular(11), color: AppColor.black, for: .normal)
    }
    
    private func initVC() {
        tfName.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tfBirthday.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        tfGender.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        tfGender.text = getLangString("gender_m")
        
        enableNext(false)
    }
    
    private func hideKeyboard() {
        tfName.resignFirstResponder()
        tfBirthday.resignFirstResponder()
        tfGender.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    private func isValidInput() {
        var isValid = true
        if isValid, tfName.text!.isEmpty {
            isValid = false
        }
        
        if isValid, tfBirthday.text!.isEmpty {
            isValid = false
        }
        
        if isValid, tfGender.text!.isEmpty {
            isValid = false
        }
        
        enableNext(isValid)
    }
    
    private func enableNext(_ enable: Bool) {
        btnNext.isEnabled = enable
        btnNext.backgroundColor = enable ? AppColor.black : AppColor.gray
    }
}

//
// MARK: - Action
//
extension SignupMainInfoVC: BaseAction {
    @IBAction func onBack(_ sender: Any) {
        hideKeyboard()
        popVC()
    }
    
    @IBAction func onClickBg(_ sender: Any) {
        hideKeyboard()
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        hideKeyboard()
        goNext()
    }
    
    @IBAction func onClickLogin(_ sender: Any) {
        replaceVC(LoginVC(nibName: "vc_login", bundle: nil), animated: true)
    }
    
    @IBAction func onClickBirthday(_ sender: Any) {
        hideKeyboard()
        DatepickerDialog.show(self) { date in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.tfBirthday.text = dateFormatter.string(from: date)
            self.isValidInput()
        }
    }
    
    @IBAction func onClickGender(_ sender: Any) {
        hideKeyboard()
        let genderOption : [String]! = [getLangString("gender_m"), getLangString("gender_f")]
        OptionsDialog.show(self, title: getLangString("dialog_title_gender"), options: genderOption) { row in
            self.tfGender.text = genderOption[row]
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        isValidInput()
    }
}

//
// MARK: - Navigation
//
extension SignupMainInfoVC: BaseNavigation {
    private func goNext() {
        let vc = SignupIdMakeVC(nibName: "vc_signup_id_make", bundle: nil)
        vc.authType = authType
        vc.authMedia = authMedia
        vc.authCode = authCode
        vc.authPwd = authPwd
        vc.authName = tfName.text!
        vc.authBithday = tfBirthday.text!
        vc.authGender = tfGender.text! == getLangString("gender_m") ? "m" : "f"
        self.pushVC(vc, animated: true)
    }
}
