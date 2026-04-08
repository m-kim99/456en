import SVProgressHUD
import UIKit

class SettingVC: BaseVC {

    @IBOutlet weak var lblPageTitle: UILabel!
    
//    @IBOutlet weak var editID: UITextField!
//    @IBOutlet weak var editPassword: UITextField!
//    @IBOutlet weak var lblVersion: UILabel!
    
    @IBOutlet weak var settingTableView: UITableView!
    
    var agreementList:[ModelAgreement] = []
    
    let infoSection: Int = 0
    let separatorSection1: Int = 1
    let versionSection: Int = 2
    let termsSection: Int = 3
    let separatorSection2: Int = 4
    let logoutSection: Int = 5
    
    
    private lazy var user: ModelUser = {
        return Rest.user
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        addHeaderSeparator()
        
        getAgreementList()
    }
    
    private func initVC() {
//        editID.text = user.uid
        
        settingTableView.register(UINib(nibName: "tvc_setting_account", bundle: nil), forCellReuseIdentifier: "accountCell")
        settingTableView.register(UINib(nibName: "tvc_setting_version", bundle: nil), forCellReuseIdentifier: "versionCell")
        settingTableView.register(UINib(nibName: "tvc_setting_normal", bundle: nil), forCellReuseIdentifier: "cell")
        settingTableView.register(UINib(nibName: "tvc_setting_logout", bundle: nil), forCellReuseIdentifier: "logoutCell")
        settingTableView.register(UINib(nibName: "tvc_separator", bundle: nil), forCellReuseIdentifier: "spaceCell")
        
//        lblVersionValue.text = getLangString("setting_latest_version_using")
    }
    
    private func onLoadAgreementSuccessed(_ agrements: ModelAgreementList) {
        self.agreementList.append(contentsOf: agrements.terms)
        var termsSectionNo = termsSection;
        if user.signup_type != 0 {
            termsSectionNo = termsSection - 2
        }
        settingTableView.reloadSections([termsSectionNo], with: .automatic)
    }
    
    //
    // MARK: - ACTION
    //

    
    @IBAction func onClickPwd(_ sender: Any) {
        ConfirmDialog.show(self, title:"setting_password_change_title"._localized, message: "setting_password_change_detail"._localized, showCancelBtn : true) { [weak self]() -> Void in
            
            let vc = FindIdVC(nibName: "vc_find_id", bundle: nil)
            vc.findIDRequest = .changePassword
            self?.pushVC(vc, animated: true)
        }
    }
    
    @IBAction func onClickLogout(_ sender: Any) {
        ConfirmDialog.show(self, title:"logout_alert_title"._localized, message: "", showCancelBtn : true) { [weak self]() -> Void in
            
            if let weakSelf = self {
                IntroVC.logOutProcess(weakSelf)
            }
        }
    }
}

extension SettingVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return user.signup_type != 0 ? 4 : 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sectionT = section;
        if user.signup_type != 0 {
            sectionT = section + 2
        }
        switch sectionT {
        case infoSection:
            return 1
        case separatorSection1:
            return 1
        case versionSection:
            return 3
        case termsSection:
            return agreementList.count
        case separatorSection2:
            return 1
        case logoutSection:
            return 2
        default:
            return 0
        }
    }

    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Fetch a cell of the appropriate type.
        
        var cellIdentifier = "cell"
        var sectionT = indexPath.section;
        if user.signup_type != 0 {
            sectionT = indexPath.section + 2
        }

        switch (sectionT, indexPath.row) {
        case (infoSection, _):
            cellIdentifier = "accountCell"
        case (separatorSection1, _):
            cellIdentifier = "spaceCell"
        case (versionSection, 0):
            cellIdentifier = "versionCell"
        case (separatorSection2, _):
            cellIdentifier = "spaceCell"
        case (logoutSection, _):
            cellIdentifier = "logoutCell"
        default:
            cellIdentifier = "cell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
       
        // Configure the cell’s contents.
        
        switch (sectionT, indexPath.row) {
        case (infoSection, _):
            if let userIDEditor = cell.viewWithTag(1) as? UITextField {
                userIDEditor.text = user.uid
            }
            
            if let changePwdButton = cell.viewWithTag(2) as? UIButton {
                if gReview {
                    changePwdButton.isHidden = true
                } else {
                    changePwdButton.isHidden = false
                    let sel = #selector(self.onClickPwd(_:))
                    changePwdButton.removeTarget(self, action:
                                                    sel, for: .touchUpInside)
                    
                    changePwdButton.addTarget(self, action: sel, for: .touchUpInside)
                }
            }
        case (versionSection, 0):
            if let versionLabel = cell.viewWithTag(1) as? UILabel {
                versionLabel.text = Utils.bundleVer()
            }
        case (versionSection, 1):
            cell.textLabel?.xibLocKey = "faq"
        case (versionSection, 2):
            cell.textLabel?.xibLocKey = "open_source_license"
        case (termsSection, _):
            cell.textLabel?.text = self.agreementList[indexPath.row].title
        case (logoutSection, 0):
            cell.textLabel?.xibLocKey = "setting_logout"
        case (logoutSection, 1):
            cell.textLabel?.xibLocKey = "setting_withdrawal"
        default:
            break
        }
        
//        cell.separatorInset = UIEdgeInsets(top: 0, left: 100000, bottom: 0, right: 0)
           
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var sectionT = indexPath.section;
        if user.signup_type != 0 {
            sectionT = indexPath.section + 2
        }
        switch (sectionT, indexPath.row) {
        case (versionSection, 0):
            self.pushVC(VersionVC(nibName: "vc_version", bundle: nil), animated: true)
        case (versionSection, 1):
            self.pushVC(FaqVC(nibName: "vc_faq", bundle: nil), animated: true)
        case (versionSection,2):
            self.pushVC(LicenseVC(nibName: "vc_license", bundle: nil), animated: true)
        case (termsSection, _):
            let agreement = agreementList[indexPath.row]
            let vc = TermsVC(nibName: "vc_terms", bundle: nil)
            vc.pageType = .term
            self.pushVC(vc, animated: true, params: ["title": agreement.title, "id": agreement.agree_id])
        case (logoutSection, 0):
            onClickLogout(1);
        case (logoutSection, 1):
            if gReview {
                ConfirmDialog.show(self, title:"user_edit_alert_title"._localized, message: "", showCancelBtn : true) { [weak self]() -> Void in
                    
                    if let weakSelf = self {
                        IntroVC.logOutProcess(weakSelf)
                    }
                }
            } else {
                self.pushVC(WithdrawalVC(nibName: "vc_withdrawal", bundle: nil), animated: true)
            }
        default:
            break
        }
    }
}

//
// MARK: - RestApi
//
extension SettingVC: BaseRestApi {
    func getAgreementList() {
        LoadingDialog.show()
        Rest.getAgreementList(isAll:true, success: { [weak self](result) -> Void in
            LoadingDialog.dismiss()
            
            let agreementList = result! as! ModelAgreementList
            self?.onLoadAgreementSuccessed(agreementList)
        }) { [weak self](code, err) -> Void in
            LoadingDialog.dismiss()
            self?.showToast(err)
        }
    }
}
