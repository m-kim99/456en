import SVProgressHUD
import SwiftyJSON
import Toast_Swift
import UIKit

enum AgreeType: Int {
    case signup = 0
    case login = 1
}

class AgreePageVC: BaseVC {
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnAllAgree: UIButton!
    @IBOutlet weak var lblAgreeHeader: UILabel!
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var agreeTableView: UITableView!
    
    
    var agreeType: AgreeType = .signup
    
    open var authType = AuthType.phone
    open var authMedia = ""
    open var authCode = ""
    
    var isAllAgree = false
    
    weak var nextDelegate: SignupNextDelegate?
    
    var agreementList:[ModelAgreement] = []
    var agreementCheckList:[Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAgreeState()
        
        if agreeType == .login {
            lblAgreeHeader.text = "login_agree_detail"._localized
            lblStep.isHidden = true
            btnNext.xibLocKey = "complete"
        } else {
            lblAgreeHeader.xibLocKey = "signup_agree_detail"._localized
        }
        
        agreeTableView.register(UINib(nibName: "tvc_agree", bundle: nil), forCellReuseIdentifier: "cell")
        
        getAgreementList()
    }
    
    private func updateAgreeState() {
        let imageName = (isAllAgree) ? "Icon-C-CheckOn-24" : "Icon-C-CheckOff-24"
        self.btnAllAgree.setImage(UIImage(named: imageName), for: .normal)
        btnNext.isEnabled = isAllAgree
    }
    
    private func onLoadAgreementSuccessed(_ agrements: ModelAgreementList) {
        for agree in agrements.terms {
            self.agreementList.append(agree)
            self.agreementCheckList.append(false)
        }
        
        agreeTableView.reloadData()
    }
}

//
// MARK: - Action
//
extension AgreePageVC: BaseAction {
    @IBAction func onClickAllAgree(_ sender: Any) {
        isAllAgree = !isAllAgree
        for i in 0..<agreementCheckList.count {
            agreementCheckList[i] = isAllAgree
        }
        updateAgreeState()
        agreeTableView.reloadData()
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        switch (isAllAgree, agreeType) {
        case (true, .login):
            goNext()
        case (true, .signup):
            showConfirm(title: "signup_agree_confrim_title".localized, message: "", showCancelBtn: true) { [weak self]() -> Void in
                self?.goNext()
            }
        case (false, _):
            showAlert(title: "signup_agree_alert_title"._localized)
        }
    }
}

//
// MARK: - Navigation
//
extension AgreePageVC: BaseNavigation {
    private func goNext() {
        nextDelegate?.onClickNext(step: .complete, params: params)
    }
}


extension AgreePageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agreementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AgreeTVC
        
        let index = indexPath.row
        cell.agreeDelgate = self
        cell.setAgreeData(agree: agreementList[index], isChecked: agreementCheckList[index])
        
        return cell
    }
}


//
// MARK: - RestApi
//
extension AgreePageVC: BaseRestApi {
    func getAgreementList() {
        LoadingDialog.show()
        let isAll:Bool = agreeType == .login ? false : true
        Rest.getAgreementList(isAll: isAll, success: { [weak self](result) -> Void in
            LoadingDialog.dismiss()
            
            let agreementList = result! as! ModelAgreementList
            self?.onLoadAgreementSuccessed(agreementList)
        }) { [weak self](code, err) -> Void in
            LoadingDialog.dismiss()
            self?.showToast(err)
        }
    }
}


extension AgreePageVC: AgreeTableCellDelegate {
    func onClickCheckItem(at: IndexPath) {
        let index = at.row
        agreementCheckList[index] = !agreementCheckList[index]
        
        isAllAgree = agreementCheckList.firstIndex(of: false) == nil
        updateAgreeState()
    }
    
    func onClickView(at: IndexPath) {
        let agreement = agreementList[at.row]
        let vc = TermsVC(nibName: "vc_terms", bundle: nil)
        self.pushVC(vc, animated: true, params: ["title": agreement.title, "id": agreement.agree_id])
    }
}
