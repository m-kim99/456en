import SVProgressHUD
import UIKit

protocol PopViewControllerDelegate {
    func onWillBack(_ sender: String, _ result: Any?)
}

class BaseVC: UIViewController {
    @IBOutlet weak var keyboardAvoidScroll: UIScrollView?
    @IBOutlet weak var hideKeyboardGesture: UITapGestureRecognizer?
    
    var params: [String: Any] = [:]
    var popDelegate: PopViewControllerDelegate?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        SVProgressHUD.setContainerView(self.view)
        LoadingDialog.setActiveController(self.navigationController)
        NotificationCenter.default.addObserver(self, selector: #selector(self.dimLink), name: NSNotification.Name(rawValue: "dimlink"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.unregisterForKeyboardNotifications()
        SVProgressHUD.popActivity()
        SVProgressHUD.dismiss()
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(BaseVC.keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BaseVC.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWasShown(_ aNotification: Notification) {
        if let tapGestuer = hideKeyboardGesture {
            tapGestuer.isEnabled = true
        }
        
        guard let scrollView = keyboardAvoidScroll, let keyboardRect = aNotification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, !keyboardRect.isEmpty else {
            return
        }
        
        scrollView.contentInset.bottom = keyboardRect.height
    }
    
    @objc func keyboardWillBeHidden(_ aNotification: Notification) {
        if let scrollView = keyboardAvoidScroll {
            scrollView.contentInset.bottom = 0
        }
        
        if let tapGestuer = hideKeyboardGesture {
            tapGestuer.isEnabled = false
        }
        
    }
  
    func replaceVC(_ identifier: String, storyboard: String, animated: Bool) {
        let nav: UINavigationController! = self.navigationController
        let storyboard: UIStoryboard! = UIStoryboard(name: storyboard, bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        
        nav.setViewControllers([vc], animated: animated)
    }
  
    func pushVC(_ identifier: String, storyboard: String, animated: Bool) {
        let nav: UINavigationController! = self.navigationController
        let storyboard: UIStoryboard! = UIStoryboard(name: storyboard, bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        nav.pushViewController(vc, animated: animated)
    }
  
    func pushVC(_ identifier: String, storyboard: String, animated: Bool, params: [String: Any]) {
        let nav: UINavigationController! = self.navigationController
        let storyboard: UIStoryboard! = UIStoryboard(name: storyboard, bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: identifier) as! BaseVC
        
        vc.params = params
        nav.pushViewController(vc, animated: animated)
    }
    
    func pushVC(_ vc: BaseVC, animated: Bool, params: [String: Any] = [:]) {
        let nav: UINavigationController! = self.navigationController
        vc.params = params
        nav.pushViewController(vc, animated: animated)
    }
    
    func replaceVC(_ vc: BaseVC, animated: Bool, params: [String: Any] = [:]) {
        let nav: UINavigationController! = self.navigationController
        vc.params = params
        nav.setViewControllers([vc], animated: animated)
    }
  
    @objc func popVC(_ backStep: Int32 = -1, animated: Bool = true) {
        let nav: UINavigationController! = self.navigationController
        
        if nav == nil {
            return
        }
    
        var viewVCs: [UIViewController] = nav.viewControllers
        for _ in 1 ... (0 - backStep) {
            viewVCs.removeLast()
        }
    
        nav.setViewControllers(viewVCs, animated: animated)
    }
    
    func popToLogVC(_ animated: Bool = true) {
        guard let vcs = self.navigationController?.viewControllers.reversed() else {
            return
        }
        
        for vc in vcs {
            if vc is LoginVC {
                self.navigationController?.popToViewController(vc, animated: animated)
                return
            }
        }
    }
    
    func popToStartVC(_ animated: Bool = true) {
        guard let vcs = self.navigationController?.viewControllers.reversed() else {
            return
        }
        
        for vc in vcs {
            if vc is IntroVC {
                self.navigationController?.popToViewController(vc, animated: animated)
                return
            }
        }
    }
  
    func presentVC(_ identifier: String, storyboard: String, animated: Bool) {
        let storyboard: UIStoryboard! = UIStoryboard(name: storyboard, bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(vc, animated: animated, completion: nil)
    }
  
    func displayContentController(content: UIViewController) {
        addChild(content)
        self.view.addSubview(content.view)
        content.didMove(toParent: self)
    }
  
    func hideContentController(content: UIViewController) {
        content.willMove(toParent: nil)
        content.removeFromParent()
        content.view.removeFromSuperview()
    }
    
    func addHeaderSeparator() {
        guard let safeAreaRoot = view.subviews.first(where: { $0.translatesAutoresizingMaskIntoConstraints == false }),
              let headerView = safeAreaRoot.subviews.first(where: { $0.translatesAutoresizingMaskIntoConstraints == false }) else { return }
        
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
        separator.translatesAutoresizingMaskIntoConstraints = false
        safeAreaRoot.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: safeAreaRoot.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: safeAreaRoot.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func hideKeyboard() {
    }
    
    func onBackProcess(_ viewController: UIViewController) {
        popVC()
    }
    
    
    
    @IBAction func onClickBG(_ sender: Any) {
        hideKeyboard()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        hideKeyboard()
        onBackProcess(self)
    }
    
    
    func showToast(localized: String) {
        showToast(localized._localized)
    }
    
    
    func showToast(_ text: String) {
        if let parentVC = parent {
            parentVC.view.showToast(text)
        } else {
            self.view.showToast(text)
        }
    }
    
    func showAlert(title: String,
                   message: String = "",
                   okAction: AlertDialog.Callback? = nil) {
        var vc: UIViewController = self
        if let parentVC = parent {
            vc = parentVC
        }
        
        AlertDialog.show(vc, title: title, message: message, okAction: okAction)
    }
    
    func showConfirm(title: String,
                     message: String,
                     showCancelBtn: Bool,
                     okAction: ConfirmDialog.Callback? = nil) {
        var vc: UIViewController = self
        if let parentVC = parent {
            vc = parentVC
        }
        
        ConfirmDialog.show(vc, title: title, message: message, showCancelBtn: showCancelBtn, okAction: okAction)
    }
    
    @objc func dimLink(_ notification: NSNotification) {
        self.goDetailPage()
    }

    func goDetailPage() {
        let link = Local.getDimLink()
        if link == "" {
            return
        }
        let strLink = link
        Local.setDimLink("")
        
        let temp = (strLink! as NSString).lastPathComponent
        let documentUID = Int(temp )
        let detailVC = DocumentDetailVC(nibName: "vc_document_detail", bundle: nil)
        detailVC.documentId = documentUID
        self.pushVC(detailVC, animated: true)
    }
}
