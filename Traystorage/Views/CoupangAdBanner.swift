import UIKit
import WebKit

class CoupangAdBanner: UIView {
    
    // TODO: 실제 쿠팡 파트너스 ID로 교체
    static let partnerId = 0
    static let trackingCode = "AF0000000"
    static let subId = ""
    
    private var webView: WKWebView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBanner()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBanner()
    }
    
    private func setupBanner() {
        backgroundColor = .white
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .white
        webView.scrollView.isScrollEnabled = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        loadAd()
    }
    
    private func loadAd() {
        guard CoupangAdBanner.partnerId != 0 else {
            isHidden = true
            return
        }
        
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
        <style>
        body { margin: 0; padding: 0; background: #fff; display: flex; justify-content: center; align-items: center; }
        </style>
        </head>
        <body>
        <script src="https://ads-partners.coupang.com/g.js"></script>
        <script>
        new PartnersCoupang.G({
            "id": \(CoupangAdBanner.partnerId),
            "template": "carousel",
            "trackingCode": "\(CoupangAdBanner.trackingCode)",
            "subId": "\(CoupangAdBanner.subId)",
            "width": "100%",
            "height": "90"
        });
        </script>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: URL(string: "https://ads-partners.coupang.com"))
    }
    
    func reload() {
        loadAd()
    }
}
