import Foundation
import UIKit

@IBDesignable
class DesignableUITextField: UITextField {
	
	let image_size = CGFloat(15)
	
	// Provides left padding for images
	override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		var textRect = super.leftViewRect(forBounds: bounds)
		textRect.origin.x += leftPadding
		return textRect
	}
	
	@IBInspectable var leftImage: UIImage? {
		didSet {
			updateView()
		}
	}
	
	@IBInspectable var leftPadding: CGFloat = 0
	
	@IBInspectable var placeholderColor = UIColor.lightGray {
		didSet {
			updateView()
		}
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		var margin = CGFloat(0)
		if let _ = leftImage {
			margin = image_size + leftPadding
		}
		var rect = bounds.insetBy(dx: margin + leftPadding, dy: 0)
		rect.size.width += leftPadding
		return rect
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		var margin = CGFloat(0)
		if let _ = leftImage {
			margin = image_size + leftPadding
		}
		var rect = bounds.insetBy(dx: margin + leftPadding, dy: 0)
		rect.size.width += leftPadding
		return rect
	}
	
	func updateView() {
		if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
			let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: image_size, height: image_size))
			imageView.image = image
			imageView.contentMode = .scaleAspectFit
			// Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
			imageView.tintColor = placeholderColor
			leftView = imageView
		} else {
            leftViewMode = UITextField.ViewMode.never
			leftView = nil
		}
		
		// Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: placeholderColor])
	}
	
}
