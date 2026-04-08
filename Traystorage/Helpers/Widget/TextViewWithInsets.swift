import UIKit

@IBDesignable class TextViewWithInsets: UITextView {

    @IBInspectable var topInset: CGFloat = 0 {
        didSet {
            self.contentInset = UIEdgeInsets(top: topInset, left: self.contentInset.left, bottom: self.contentInset.bottom, right: self.contentInset.right)
        }
    }

    @IBInspectable var bottmInset: CGFloat = 0 {
        didSet {
            self.contentInset = UIEdgeInsets(top: self.contentInset.top, left: self.contentInset.left, bottom: bottmInset, right: self.contentInset.right)
        }
    }

    @IBInspectable var leftInset: CGFloat = 0 {
        didSet {
            self.contentInset = UIEdgeInsets(top: self.contentInset.top, left: leftInset, bottom: self.contentInset.bottom, right: self.contentInset.right)
        }
    }

    @IBInspectable var rightInset: CGFloat = 0 {
        didSet {
            self.contentInset = UIEdgeInsets(top: self.contentInset.top, left: self.contentInset.left, bottom: self.contentInset.bottom, right: rightInset)
        }
    }
}
