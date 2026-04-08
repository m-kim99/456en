import UIKit

extension UIColor {
    convenience init(hex: Int) {
        let components = (
          R: CGFloat((hex >> 16) & 0xff) / 255,
          G: CGFloat((hex >> 08) & 0xff) / 255,
          B: CGFloat((hex >> 00) & 0xff) / 255
        )
    
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    convenience init(hex: Int, alpha: CGFloat) {
        let components = (
          R: CGFloat((hex >> 16) & 0xff) / 255,
          G: CGFloat((hex >> 08) & 0xff) / 255,
          B: CGFloat((hex >> 00) & 0xff) / 255
        )
    
        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
  
    func rgb() -> Int? {
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
      
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
  
    var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h: h, s: s, b: b, a: a)
    }
}
