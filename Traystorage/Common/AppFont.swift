import Foundation
import SwiftyJSON
import UIKit

class AppFont {
    
    static var fontFamilyName = "Apple SD Gothic Neo"
    
    static func appleGothicNeoRegular(_ size: CGFloat) -> UIFont {
        return createFont(name: fontFamilyName, size: size)
    }
    
    static func appleGothicNeoBlack(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Black", size: size)!
    }
    
    static func appleGothicNeoBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Apple SD Gothic Neo Bold", size: size)!
    }
    
    
    static func createFont(name: String, size: CGFloat) -> UIFont {
        guard let f = UIFont(name: name, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        
        return f
    }
    
    static func createBoldFont(name: String, size: CGFloat) -> UIFont {
        let fontDes = UIFontDescriptor(name: name, size: size)
        guard let boldFontDes = fontDes.withSymbolicTraits(.traitBold) else {
            return createFont(name: name, size: size)
        }
        
        return UIFont(descriptor: boldFontDes, size: size)
    }
}
