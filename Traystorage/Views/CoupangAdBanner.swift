import UIKit
import WebKit

class CoupangAdBanner: UIView {
    
    static let widgetId = 971272
    static let trackingCode = "AF1883524"
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
        let html = "<html><head><style>body{margin:0;padding:0;}</style></head><body>"
            + "<iframe src='https://ads-partners.coupang.com/widgets.html?id=\(CoupangAdBanner.widgetId)&template=carousel&trackingCode=\(CoupangAdBanner.trackingCode)&subId=\(CoupangAdBanner.subId)&width=680&height=210&tsource=' "
            + "width='100%' height='210' frameborder='0' scrolling='no' referrerpolicy='unsafe-url'></iframe>"
            + "</body></html>"
        
        webView.loadHTMLString(html, baseURL: URL(string: "https://ads-partners.coupang.com"))
    }
    
    func reload() {
        loadAd()
    }
}
