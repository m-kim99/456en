import Foundation
import UIKit
import Material

@IBDesignable
class FontTextField: TextField {
    @IBInspectable var fontFamily: String = AppFont.fontFamilyName {
        didSet {
            self.font = textFont()
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 15.0 {
        didSet {
            self.font = textFont()
        }
    }
    
    @IBInspectable var isBold: Bool = false {
        didSet {
            self.font = textFont()
        }
    }
    
    @IBInspectable var useCustomeDivierActive: Bool = true {
        didSet {
            if useCustomeDivierActive {
                self.dividerActiveColor = UIColor.black
            }
        }
    }
    
    @IBInspectable var closeButtonOffset: CGFloat = CGFloat.zero
    
    func textFont() -> UIFont {
        if isBold {
            return AppFont.createBoldFont(name: fontFamily, size: fontSize)
        }
        return AppFont.createFont(name: fontFamily, size: fontSize)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if useCustomeDivierActive {
            self.dividerActiveColor = UIColor.black
        }
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.clearButtonRect(forBounds: bounds)
        if closeButtonOffset != CGFloat.zero {
            return rect.offsetBy(dx: -closeButtonOffset, dy: 0)
        }
        
        return rect
    }
}

extension TextField {
    @IBInspectable var xibPlaceholder: String? {
        set(value) {
            super.placeholder = value?._localized
        }
        get {
            return super.placeholder
        }
    }
}
