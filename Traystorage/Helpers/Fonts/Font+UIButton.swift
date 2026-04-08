import Foundation
import UIKit

@IBDesignable
class UIFontButton: UIButton {
    
    let buttonRadius: CGFloat = 5
    @IBInspectable var fontFamily: String = AppFont.fontFamilyName {
        didSet {
            self.titleLabel?.font = buttonFont()
        }
    }
    
    // avoid conflict with "Material.fontSize"
    @IBInspectable var xFontSize: CGFloat = 14.0 {
        didSet {
            self.fontSize = xFontSize
        }
    }
    
    @IBInspectable var isOutline: Bool = false {
        didSet {
            if (isOutline) {
                self.borderColor = AppColor.active
                self.borderWidth = 1
            }
        }
    }
    
    @IBInspectable var isBold: Bool = false {
        didSet {
            self.titleLabel?.font = buttonFont()
        }
    }
    
    @IBInspectable var isFilled: Bool = false {
        didSet {
            refreshButton()
        }
    }
    
    @IBInspectable var useCustomeRadius: Bool = false {
        didSet {
            if useCustomeRadius {
                cornerRadius = buttonRadius
            }
        }
    }
    
    @IBInspectable var useAppTint: Bool = false {
        didSet {
            refreshButton()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            refreshButton()
        }
    }
    
    func refreshButton() {
        backgroundColor = self.buttonBackgroundColor()
        setTitleColor(buttonTitleColor(), for: .normal)
        self.borderColor = buttonBorderColor()
        self.tintColor = buttonTintColor()
    }
    
    func buttonFont() -> UIFont {
        if isBold {
            return AppFont.createBoldFont(name: fontFamily, size: fontSize)
        }
        
        return AppFont.createFont(name: fontFamily, size: fontSize)
    }
    
    func buttonBackgroundColor() -> UIColor? {
        let buttonState = (isEnabled, isFilled)
        switch buttonState {
        case (true, true):
            return AppColor.active
        case (false, true):
            return AppColor.lightlightGray
        case (_, false):
            break
        }
        return self.backgroundColor
    }
    
    func buttonTitleColor() -> UIColor? {
        let buttonState = (isEnabled, isFilled)
        switch buttonState {
        case (true, true):
            return AppColor.white
        case (false, true):
            return AppColor.gray
        case (true, false):
            break
        case (false, false):
            return AppColor.gray
        }
        return nil
    }
    
    func buttonTintColor() -> UIColor? {
        let buttonState = (isEnabled, useAppTint)
        switch buttonState {
        case (_, false):
            break
        case (true, _):
            return AppColor.active
        case (false, _):
            return AppColor.gray
        }
        return super.tintColor
    }
    
    func buttonBorderColor() -> UIColor? {
        let buttonState = (isEnabled, isOutline)
        switch buttonState {
        case (_, false):
            break
        case (true, _):
            return AppColor.active
        case (false, _):
            return AppColor.gray
        }
        return nil
    }
}

