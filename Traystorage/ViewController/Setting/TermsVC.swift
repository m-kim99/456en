import SVProgressHUD
import UIKit
import WebKit

enum WebPageType: Int {
    case term = 0
    case privacy = 1
    case marketing = 2
}

class TermsVC: BaseVC {
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var vwTermsWeb: WKWebView!
    
    var pageType: WebPageType = .term
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        switch pageType {
//        case .term:
//            params["title"] = "terms_of_use"._localized
//            params["url"] = API_TERM_URL
//        case .privacy:
//            params["title"] = "privacy_policy"._localized
//            params["url"] = API_PRIVACY_URL
//        case .marketing:
//            params["title"] = "marketing_consent"._localized
//            params["url"] = API_MARKETING_URL
//        }
        
        initVC()
    }
    
    private func initVC() {
        if let title = params["title"] as? String {
            lblPageTitle.text = title
        }
        
        if let agreeID = params["id"] as? Int {
            getAgreementDetail(agreeID: agreeID)
        }
    }
    
    private func onLoadAgreement(agree: ModelAgreement) {
        vwTermsWeb.loadHTMLString(agree.content, baseURL: nil)
    }
    
    //
    // MARK: - ACTION
    //
    
}


//
// MARK: - RestApi
//
extension TermsVC: BaseRestApi {
    func getAgreementDetail(agreeID: Int) {
        LoadingDialog.show()
        Rest.getAgreementDetail(agreeID: agreeID, success: { [weak self](result) -> Void in
            LoadingDialog.dismiss()
            self?.onLoadAgreement(agree: result! as! ModelAgreement)
        }) { [weak self](code, err) -> Void in
            LoadingDialog.dismiss()
            self?.showToast(err)
        }
    }
}
