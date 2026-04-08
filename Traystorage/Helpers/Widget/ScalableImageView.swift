import UIKit
import Kingfisher
import AVFoundation

class ScalableImageView: UIScrollView, UIScrollViewDelegate {

    var m_strFileURL : String!
    var m_imageView : UIImageView!
    
    func setFileURL(_ strFileURL : String) {
        m_strFileURL = strFileURL
        m_imageView.kf.setImage(with: URL(string: m_strFileURL))
        resetLayout()
    }
    
    func setImage(_ image : UIImage) {
        m_imageView.image = image
        resetLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initUI()
    }
    
    override func awakeFromNib() {
        self.initUI()
    }
    
    func initUI() {
        m_imageView = UIImageView()
        m_imageView.contentMode = .scaleAspectFill
        self.addSubview(m_imageView)
        
        self.delaysContentTouches = false
        self.delegate = self
        self.maximumZoomScale = 5.0
        self.minimumZoomScale = 1.0
        self.contentSize = CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    func resetLayout() {
        if let image = m_imageView.image {
            m_imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            let frame = AVMakeRect(aspectRatio: m_imageView.frame.size, insideRect: CGRect(origin: .zero, size: CGSize(width: self.frame.size.width, height: self.frame.size.height)))
            m_imageView.frame = frame
        }
    
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return m_imageView
    }
    
    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        return false
    }
}
