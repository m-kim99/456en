import Foundation
import UIKit

@IBDesignable
class UIFontTextField: UITextField {
    @IBInspectable var fontFamily: String = AppFont.fontFamilyName {
        didSet {
            self.font = textFont()
        }
    }
    
    @IBInspectable var xFontSize: CGFloat = 15.0 {
        didSet {
            self.font = self.font?.withSize(xFontSize)
        }
    }
    
    @IBInspectable var isBold: Bool = false {
        didSet {
            self.font = textFont()
        }
    }
    
    @IBInspectable var closeButtonOffset: CGFloat = CGFloat.infinity
    
    func textFont() -> UIFont {
        if isBold {
            return AppFont.createBoldFont(name: fontFamily, size: xFontSize)
        }
        return AppFont.createFont(name: fontFamily, size: xFontSize)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.clearButtonRect(forBounds: bounds)
        if closeButtonOffset != CGFloat.infinity {
            return rect.offsetBy(dx: -closeButtonOffset, dy: 0)
        }
        
        return rect
    }
    
    @IBInspectable var xibPlaceholder: String? = nil {
        didSet {
            super.placeholder = xibPlaceholder?._localized
        }
    }
}
