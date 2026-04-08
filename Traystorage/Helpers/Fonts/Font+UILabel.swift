import Foundation
import UIKit

@IBDesignable
class UIFontLabel: UILabel {
    @IBInspectable var fontFamily: String = AppFont.fontFamilyName {
        didSet {
            self.font = labelFont()
        }
    }
    
    // avoid conflict with "Material.fontSize"
    @IBInspectable var xFontSize: CGFloat = 14.0 {
        didSet {
            self.fontSize = xFontSize
        }
    }
    
    @IBInspectable var lineHeight: CGFloat = 1.0 {
        didSet {
            setLineHeight(lineHeight: lineHeight)
        }
    }
    
    
    @IBInspectable var isBold: Bool = false {
        didSet {
            self.font = labelFont()
        }
    }
    
    
    func labelFont() -> UIFont {
        if isBold {
            return AppFont.createBoldFont(name: fontFamily, size: fontSize)
        }
        
        return AppFont.createFont(name: fontFamily, size: fontSize)
    }
}
