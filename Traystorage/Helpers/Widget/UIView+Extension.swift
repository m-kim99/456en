import Foundation
import UIKit
import Toast_Swift

@IBDesignable
extension UIView {
    class func initWithNibName(_ nibName: String) -> UIView {
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return safeAreaLayoutGuide.leftAnchor
        } else {
            return leftAnchor
        }
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return safeAreaLayoutGuide.rightAnchor
        } else {
            return rightAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }
    
    @IBInspectable var topCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: newValue, height: newValue))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var bottomCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: newValue, height: newValue))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var leftCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: newValue, height: newValue))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var rightCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: newValue, height: newValue))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var topBottomCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.topLeft.union(.bottomRight)], cornerRadii: CGSize(width: newValue, height: newValue))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var topLeftNoneCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight, .topRight], cornerRadii: CGSize(width: newValue, height: newValue))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var topRightNoneCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: newValue, height: newValue))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var bottomRightNoneCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .bottomLeft, .topRight], cornerRadii: CGSize(width: newValue, height: newValue))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var bottomLeftNoneCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .bottomRight, .topRight], cornerRadii: CGSize(width: newValue, height: newValue))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
            self.layer.masksToBounds = true
        }
    }
    
    func showToast(_ msg: String) {
        var style = ToastStyle()
        style.messageColor = UIColor.white
        self.makeToast(msg, duration: 2.0, position: .bottom, style: style)
    }
    
    func setShadow(radius: CGFloat = 1.0) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: radius, height: radius)
        self.layer.shadowRadius = radius
        self.clipsToBounds = false
    }
    
    func setShadow(cornerRadius: CGFloat, shadowRadius: CGFloat = 1.0, opacity: Float = 0.5, offset: CGSize = CGSize(width: 0, height: 0)) {
        self.layer.cornerRadius = cornerRadius
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = shadowRadius
    }
    
    func removeAllSubviews() {
        for item in self.subviews {
            item.removeFromSuperview()
        }
    }
    
    func createFont(name: String, size: CGFloat) -> UIFont {
        //print("fontName", name)
        if let f = UIFont(name: name, size: size) {
            return f
        }
        //print(name, "nil")
        return UIFont.systemFont(ofSize: size)
    }
    
    
    func addSubView(subView: UIView, isFull: Bool) {
        self.addSubview(subView)
        
        guard isFull else {
            return
        }
        
        let views:[String:Any] = ["view" : subView]

        let constraints1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[view]-|", options: [], metrics: nil, views: views)
        let constraints2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[view]-|", options: [], metrics: nil, views: views)
        subView.translatesAutoresizingMaskIntoConstraints = false

        addConstraints(constraints1)
        addConstraints(constraints2)
    }
}
