import Foundation
import UIKit

@IBDesignable
class UIFontTextView: UITextView {
    @IBInspectable var fontFamily: String = "System" {
        didSet {
            self.font = createFont(name: fontFamily, size: fontSize)
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 10.0 {
        didSet {
            self.font = createFont(name: fontFamily, size: fontSize)
        }
    }
}
