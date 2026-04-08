import UIKit

//import Material

@IBDesignable
extension UITextField {
    func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }

        return super.canPerformAction(action, withSender: sender)
    }

    @IBInspectable var paddingLeft: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }

    @IBInspectable var paddingRight: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }

    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
        leftView = paddingView
        leftViewMode = .always
    }

    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
        rightView = paddingView
        rightViewMode = .always
    }
    
    func setPlaceHolderSuper(_ placeholder: String?) {
//        self.placeholder = placeholder
//        (self as UITextField).placeholder = placeholder
    }
}


//extension TextField {
//    func setPlaceHolderSuper(_ placeholder: String?) {
//        super.placeholder = placeholder
//    }
//}
