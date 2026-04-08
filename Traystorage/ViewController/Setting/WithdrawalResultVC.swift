import SVProgressHUD
import UIKit

class WithdrawalResultVC: BaseVC {
    @IBOutlet var lblPageTitle: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblDesc: UIFontLabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        initVC()
    }

    private func initVC() {
        lblDate.text = params["date"] as? String

//        let myString: NSString = "14일 이내 재로그인 시 탈퇴회원복구 절차를\n진행 하실 수 있습니다."
//        var myMutableString = NSMutableAttributedString()
//        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)])
//        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 14))
//        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hex: 0x1E319D), range: NSRange(location: 15, length: 20))
//        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 21, length: 25))
//        lblDesc.attributedText = myMutableString
        
        let string = "withdrawal_result_3"._localized
        let data = string.data(using: String.Encoding.utf8)!
        do {

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
            lblDesc.attributedText = attrString
        }
        catch let error {
            print("invalid attributed string: \(error.localizedDescription)")
            lblDesc.text = string
        }
    }

    //

    // MARK: - ACTION

    //

    @IBAction func onClickConfirm(_ sender: Any) {
        IntroVC.logOutProcess(self)
    }
}
