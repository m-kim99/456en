import SVProgressHUD
import UIKit

class WithdrawalVC: BaseVC {

    @IBOutlet weak var lblPageTitle: UILabel!
    
    @IBOutlet weak var lblContent: UIFontLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVC()
    }
    
    private func initVC() {
        let string = "withdrawal_content"._localized
        let data = string.data(using: String.Encoding.utf8)!
        do {
//            var attrs:NSDictionary? = NSDictionary(object:[NSAttributedString.Key.font : AppFont.appleGothicNeoRegular(15)], forKey:NSAttributedString.DocumentAttributeKey.defaultAttributes.rawValue as NSCopying)
            let regularFont = AppFont.appleGothicNeoRegular(15)
            let boldFont = AppFont.appleGothicNeoBold(15)
            let attrString = try NSMutableAttributedString(data: data, options:[.documentType: NSAttributedString.DocumentType.html, .characterEncoding : String.Encoding.utf8.rawValue], documentAttributes: nil)// &attrs)
            attrString.enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, attrString.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { value, range, _ in
                let font = value as! UIFont
                if font.fontDescriptor.symbolicTraits.contains(.traitBold) {
                    attrString.addAttributes([NSAttributedString.Key.font : boldFont], range: range)
                } else {
                    attrString.addAttributes([NSAttributedString.Key.font : regularFont], range: range)
                }
            }
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = 1.5
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paraStyle, range: NSMakeRange(0, attrString.length))
            lblContent.attributedText = attrString
        }
        catch let error {
            print("invalid attributed string: \(error.localizedDescription)")
            lblContent.text = string
        }
    }
    
    //
    // MARK: - ACTION
    //
    

    @IBAction func onClickWithdrawal(_ sender: Any) {
        let vc = FindIdVC(nibName: "vc_find_id", bundle: nil)
        vc.findIDRequest = .withDrawal
        self.pushVC(vc, animated: true)
    }
}

//
// MARK: - RestApi
//
extension WithdrawalVC: BaseRestApi {
    func getContent(type: String, alarm_yn: String) {
//        LoadingDialog.show()
//        Rest.changeAlarm(type: type, alarm_yn: alarm_yn, success: { (result) -> Void in
//            LoadingDialog.dismiss()
//            if result?.result == 0 {
//                if type == "push" {
//                    self.user.alarm_push_yn = alarm_yn
//                    self.lblPushAllowValue.text = (self.user.alarm_push_yn == "y") ? getLangString("setting_on") : getLangString("setting_off")
//                    self.btnPushAllow.isSelected = (self.user.alarm_push_yn == "y")
//                } else {
//                    self.user.alarm_challenge_yn = alarm_yn
//                    self.lblChallengeValue.text = (self.user.alarm_challenge_yn == "y") ? getLangString("setting_on") : getLangString("setting_off")
//                    self.btnChallengeAlarm.isSelected = (self.user.alarm_challenge_yn == "y")
//                }
//
//                Local.setUser(self.user)
//            }
//        }, failure: { (_, err) -> Void in
//            LoadingDialog.dismiss()
//            self.view.showToast(err)
//        })
    }
}
