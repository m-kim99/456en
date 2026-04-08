import UIKit

@IBDesignable
extension UIButton {
    open override func awakeFromNib() {
        super.awakeFromNib()
//        titleLabel?.highlightedTextColor = UIColor.gray
    }
    
//    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        let hitArea = self.bounds.insetBy(dx: -20, dy: -20)
//        return hitArea.contains(point)
//    }
//
//    func setUnderlineTitle(_ title: String, color: UIColor, for state: UIControl.State) {
//        let attrs = [
//            NSAttributedString.Key.foregroundColor: color,
//            NSAttributedString.Key.underlineStyle: 1
//            ] as [NSAttributedString.Key : Any]
//        let attributeString = NSMutableAttributedString(string: "")
//        let title = NSMutableAttributedString(string: title, attributes: attrs)
//        attributeString.append(title)
//        self.setAttributedTitle(attributeString, for: state)
//    }
    
    

}
