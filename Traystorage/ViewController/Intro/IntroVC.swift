import AuthenticationServices
import AVFoundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import Photos
import SVProgressHUD
import Toast_Swift
import UIKit

class IntroVC: BaseVC {
    @IBOutlet var pageScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var introView: UIView!
    @IBOutlet var loadingProgressView: UIView!
    @IBOutlet var startView: UIView!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var loadingImage1: UIImageView!
    @IBOutlet var loadingImage2: UIImageView!
    @IBOutlet var loadingImage3: UIImageView!
    @IBOutlet var SNSView: UIStackView!
    
    let pageCount = 2
    private var currentPage = 0
    var slidingTimer: Timer?
    
    var loadingImageOffset = 0
    var loadingImages: [UIImage] = []
    var loadingProgressTimer: Timer?
    
    private var snsManager: SnsManager!
    
    // MARK: - Splash & New Intro Properties
    private var splashView: UIView?
    private var splashLogoImageView: UIImageView?
    private var newIntroView: UIView?
    private var newIntroScrollView: UIScrollView?
    private var introCurrentPage: Int = 0
    private let introTotalPages = 5
    private var indicatorDots: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        snsManager = SnsManager(self)
        snsManager.delegate = self

        signupButton.layer.shadowOpacity = 0.2
        signupButton.layer.shadowOffset = CGSize.zero
        signupButton.layer.shadowRadius = 8
        signupButton.layer.masksToBounds = false
        
        loadingImages.append(UIImage(named: "loading1")!)
        loadingImages.append(UIImage(named: "loading2")!)
        loadingImages.append(UIImage(named: "loading3")!)

//        loadAppInfo()
//        nextScreen(false)
//        ConfirmDialog.show(self, title: "Please verify your mobile phone number.", message: "", showCancelBtn: true, okAction: nil)

//        pushVC(WithdrawalVC(nibName: "vc_withdrawal", bundle: nil), animated: true)
//        pushVC(SignupCompleteVC(nibName: "vc_signup_complete", bundle: nil), animated: true)
        
        // 심사중인가를 체크
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let openDate = dateFormatter.date(from: "2024-01-22")!
        let today = dateFormatter.date(from: result)!
        
        if today.compare(openDate) == .orderedDescending {
            gAppStoreReview = false
        } else if today.compare(openDate) == .orderedSame {
            gAppStoreReview = false
        } else {
            gAppStoreReview = true
        }
        
        showSplash()
    }

    // MARK: - Splash Animation
    
    private func showSplash() {
        let splash = UIView(frame: view.bounds)
        splash.backgroundColor = .white
        splash.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let logoIV = UIImageView(image: UIImage(named: "ic_intro_logo"))
        logoIV.contentMode = .scaleAspectFit
        logoIV.translatesAutoresizingMaskIntoConstraints = false
        logoIV.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        splash.addSubview(logoIV)
        
        NSLayoutConstraint.activate([
            logoIV.centerXAnchor.constraint(equalTo: splash.centerXAnchor),
            logoIV.centerYAnchor.constraint(equalTo: splash.centerYAnchor),
            logoIV.widthAnchor.constraint(equalToConstant: 120),
            logoIV.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        view.addSubview(splash)
        splashView = splash
        splashLogoImageView = logoIV
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.splashPhase2()
        }
    }
    
    private func splashPhase2() {
        guard let logoIV = splashLogoImageView else { return }
        
        UIView.transition(with: logoIV, duration: 0.3, options: .transitionCrossDissolve) {
            logoIV.image = UIImage(named: "img_intro_logo_text")
            logoIV.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
        logoIV.constraints.forEach { c in
            if c.firstAttribute == .width { c.constant = 280 }
            if c.firstAttribute == .height { c.constant = 70 }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.onSplashComplete()
        }
    }
    
    private func onSplashComplete() {
        startIntro()
    }
    
    private func hideSplash() {
        UIView.animate(withDuration: 0.3, animations: {
            self.splashView?.alpha = 0
        }) { _ in
            self.splashView?.removeFromSuperview()
            self.splashView = nil
            self.splashLogoImageView = nil
        }
    }

    // MARK: - Intro Flow
    
    func startIntro() {
        let ud = UserDefaults.standard
        
        let isAutoLogin = ud.bool(forKey: Local.PREFS_APP_AUTO_LOGIN.rawValue)
        if isAutoLogin {
            hideSplash()
            checkVersion()
        } else {
            Local.deleteUser()

            let skipIntro = ud.bool(forKey: Local.PREFS_APP_INTRO_SKIP.rawValue)
            if skipIntro {
                hideSplash()
                checkVersion()
            } else {
                hideSplash()
                showNewIntro()
            }
        }
    }
    
    func stopSlidingTimer() {
        if let timer = slidingTimer {
            timer.invalidate()
            slidingTimer = nil
        }
    }
    
    func startApp() {
        let user = Local.getUser()
        
        if let uid = user.uid, let pwd = user.pwd, !uid.isEmpty, !pwd.isEmpty {
            autoLogin((id: uid, pwd: pwd))
        } else {
            nextScreen(false)
            Local.removeAutoLogin()
        }
    }

    func nextScreen(_ logined: Bool) {
        if logined {
            openAgreeView()
        } else {
            let ud = UserDefaults.standard
            ud.set(true, forKey: Local.PREFS_APP_INTRO_SKIP.rawValue)
            ud.synchronize()
            openLogSingupView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard newIntroView == nil else { return }
        onChangedPage(currentPage)
        pageScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(currentPage), y: 0), animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard newIntroView == nil else { return }
        setupPage()
    }
    
    private func setupPage() {
        pageScrollView.contentOffset = CGPoint(x: view.frame.width * CGFloat(pageCount), y: 0)
        onChangedPage(currentPage)
        pageScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(currentPage), y: 0), animated: false)
    }
    
    func onChangedPage(_ index: Int!) {
        currentPage = index
        pageControl.currentPage = index
    }
    
    func advanceLoaddingImage() {
        loadingImageOffset += 1
        loadingImageOffset %= 3
        
        loadingImage1.image = loadingImages[loadingImageOffset % 3]
        loadingImage2.image = loadingImages[(loadingImageOffset + 1) % 3]
        loadingImage3.image = loadingImages[(loadingImageOffset + 2) % 3]
    }
    
    func changeLoadingViewVisiblity(isHidden: Bool) {
        loadingProgressView.isHidden = isHidden
        if isHidden {
            stopLoadingProgressTimer()
        } else {
            startLoadingProgressTimer()
        }
    }
    
    func startLoadingProgressTimer() {
        stopLoadingProgressTimer()
        
        loadingProgressTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: { [weak self] _ in
            self?.advanceLoaddingImage()
        })
    }
    
    func stopLoadingProgressTimer() {
        if let timer = loadingProgressTimer {
            timer.invalidate()
            loadingProgressTimer = nil
        }
    }
    
    static func logOutProcess(_ fromVC: UIViewController) {
        Local.deleteUser()
        Rest.user = nil
        Local.removeAutoLogin()
        
        if let nv = fromVC.navigationController {
            let vcs = nv.viewControllers
            for vc in vcs {
                if vc is IntroVC {
                    let introVC = vc as! IntroVC
                    introVC.openLogSingupView()
                    nv.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
    
    func onGetVersionSuccess(_ latestVersion: ModelVersion) {
        let curVersion = Utils.bundleVer()
        
        if latestVersion.version.isEmpty || curVersion.compare(latestVersion.version, options: .numeric) == .orderedDescending || curVersion.compare(latestVersion.version, options: .numeric) == .orderedSame {
            startApp()
            return
        }
        
        if latestVersion.requireUpdate == 1 {
            ConfirmDialog.show3(self, title: "update_version"._localized, message: "", okTitle: "update"._localized, cancelTitle: nil) { [weak self] result -> Void in
                if result == 0 {
                    self?.go2Store(latestVersion.storeUrl)
                } else {
                    self?.startApp()
                }
            }
        } else if let optionalVersion = Local.getAppVersion(), optionalVersion.isEqual(latestVersion.version) {
            startApp()
        } else {
            ConfirmDialog.show3(self, title: "update_version"._localized, message: "", okTitle: "update"._localized, cancelTitle: "later"._localized) { [weak self] result -> Void in
                if result == 0 {
                    self?.go2Store(latestVersion.storeUrl)
                } else {
                    if latestVersion.requireUpdate != 1 {
                        Local.setAppVersion(latestVersion.version)
                    }
                    self?.startApp()
                }
            }
        }
    }
    
    func go2Store(_ storeUrl: String) {
        guard let url = URL(string: storeUrl) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }

    // MARK: - Action

    //

    @IBAction func onSwipe(_ sender: Any) {
        guard newIntroView == nil else { return }
        if let recognizer = sender as? UISwipeGestureRecognizer {
            if recognizer.direction == .left {
                if currentPage == 1 {
                    return
                }
                onChangedPage(currentPage + 1)
                pageScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(currentPage), y: 0), animated: true)
            } else if recognizer.direction == .right {
                if currentPage == 0 {
                    return
                }
                onChangedPage(currentPage - 1)
                pageScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(currentPage), y: 0), animated: true)
            }
        }
    }

    @IBAction func onClickSkip(_ sender: Any) {
        nextScreen(false)
    }
    
    func snsLogin(_id: String, _pwd: String, _type: Int) {
        changeLoadingViewVisiblity(isHidden: false)
        Rest.login(id: _id, pwd: _pwd, success: { [weak self] result -> Void in
            self?.changeLoadingViewVisiblity(isHidden: true)
            Rest.user = (result as! ModelUser)
            Rest.user.pwd = _pwd
            Local.setUser(Rest.user)
            self?.openAgreeView()
        }, failure: { [weak self] code, _ in
            self?.changeLoadingViewVisiblity(isHidden: true)
                
            let resposeCode = ResponseResultCode(rawValue: code) ?? .ERROR_SERVER
            let code = resposeCode.rawValue
            if code > 200 {
                let vc = SignupVC(nibName: "vc_signup", bundle: nil)
                vc.snsType = _type
                vc.snsID = _id
                self!.pushVC(vc, animated: true)
            }
        })
    }
}

//

// MARK: - RestApi

//
extension IntroVC: BaseNavigation {
    func openMainVC() {
        changeLoadingViewVisiblity(isHidden: true)
        hideSplash()
        hideNewIntro()
        let mainVC = UIStoryboard(name: "vc_main", bundle: nil).instantiateInitialViewController()
        pushVC(mainVC! as! BaseVC, animated: true)
    }
    
    func openAgreeView() {
        changeLoadingViewVisiblity(isHidden: true)
        hideSplash()
        hideNewIntro()
        if Rest.user.isAgree == 0 {
            pushVC(LoginAgreeTermsVC(nibName: "vc_login_agree_terms", bundle: nil), animated: true)
        } else {
            openMainVC()
        }
    }

    func openLogSingupView() {
//        self.replaceVC(GuideVC(nibName: "vc_guide", bundle: nil), animated: true)
        changeLoadingViewVisiblity(isHidden: true)
        hideSplash()
        hideNewIntro()
        introView.isHidden = true
        startView.isHidden = false
    }
    
    @IBAction func onSignup(_ sender: Any) {
        pushVC(SignupVC(nibName: "vc_signup", bundle: nil), animated: true)
    }
    
    @IBAction func onLogin(_ sender: Any) {
//        replaceVC(LoginVC(nibName: "vc_login", bundle: nil), animated: true)
        pushVC(LoginVC(nibName: "vc_login", bundle: nil), animated: true)
    }
    
    @IBAction func onSignupSNS(_ sender: UIButton) {
        // onSignup(sender)
        
        if sender.tag == 0 {
            // kakao
            snsManager.start(type: .Kakao)
        } else if sender.tag == 1 {
            // google
//             snsManager.start(type: .Google)
            //guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let config = GIDConfiguration(clientID: GOOGLEKEY)
            GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
                if let error = error {
                    self.view.showToast("구글정보를 얻어올수 없습니다.")
                    return
                }
                let snsId = user?.userID
                self.snsLogin(_id: snsId!, _pwd: snsId!, _type: 1)
            }
        } else if sender.tag == 2 {
            // facebook
            snsManager.start(type: .Facebook)
        } else if sender.tag == 3 {
            // naver
            snsManager.start(type: .Naver)
        } else {
            // apple
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
}

extension IntroVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let err = error as? ASAuthorizationError

        var errKorMsg = ""
        if err!.errorCode == ASAuthorizationError.Code.failed.rawValue { // FAILED
        } else if err!.errorCode == ASAuthorizationError.Code.canceled.rawValue { // CANCELED
            errKorMsg = "apple_login_fail1".localized
        } else if err!.errorCode == ASAuthorizationError.Code.invalidResponse.rawValue { // INVALID_RESPONSE
            errKorMsg = "apple_login_fail2".localized
        } else if err!.errorCode == ASAuthorizationError.Code.notHandled.rawValue { // NOT_HANDLED
            errKorMsg = "apple_login_fail3".localized
        } else if err!.errorCode == ASAuthorizationError.Code.unknown.rawValue { // UNKNOWN
        }

        if errKorMsg == "" {
            return
        }
        let alert = UIAlertController(title: "alarm".localized, message: errKorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "confirm".localized, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            // For the purpose of this demo app, store the these details in the keychain.
            print("User Id - \(appleIDCredential.user)")
            print("User Name - \(appleIDCredential.fullName?.description ?? "N/A")")
            print("User Email - \(appleIDCredential.email ?? "N/A")")
            print("Real User Status - \(appleIDCredential.realUserStatus.rawValue)")

            if let identityTokenData = appleIDCredential.identityToken,
               let identityTokenString = String(data: identityTokenData, encoding: .utf8)
            {
                print("Identity Token \(identityTokenString)")
            }

            let _appid = appleIDCredential.user
//            loginType = "7"
            let snsId = _appid.replacingOccurrences(of: ".", with: "")
            snsLogin(_id: snsId, _pwd: snsId, _type: 4)

        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password

            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
                let alertController = UIAlertController(title: "Keychain Credential Received",
                                                        message: message,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension IntroVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

//

// MARK: - RestApi

//
extension IntroVC: BaseRestApi {
//    func loadAppInfo() {
//        LoadingDialog.show()
//        Rest.appInfo(success: { (result) -> Void in
//            LoadingDialog.dismiss()
//            Local.setAppInfo(result as! ModelAppInfo)
//
//            DispatchQueue.global().async {
//                Thread.sleep(forTimeInterval: 1.0)
//                DispatchQueue.main.async {
//                    self.startApp()
//                }
//            }
//        }, failure: { (_, err) -> Void in
//            LoadingDialog.dismiss()
//            self.view.showToast(err)
//        })
//    }

    func autoLogin(_ user: (id: String, pwd: String)) {
//        LoadingDialog.show()
        changeLoadingViewVisiblity(isHidden: false)
        Rest.login(id: user.id, pwd: user.pwd, success: { [weak self] result -> Void in
//            LoadingDialog.dismiss()
            self?.changeLoadingViewVisiblity(isHidden: true)
            Rest.user = (result as! ModelUser)
            Rest.user.pwd = user.pwd
            Local.setUser(Rest.user)
            self?.openAgreeView()
        }, failure: { [weak self] code, msg in
            // LoadingDialog.dismiss()
            self?.changeLoadingViewVisiblity(isHidden: true)
            
            let resposeCode = ResponseResultCode(rawValue: code) ?? .ERROR_SERVER
            
            switch resposeCode {
            case .ERROR_SERVER:
//                AlertDialog.show(self?, title: "network_conect_fail_title"._localized, message: "network_conect_fail_desc"._localized);
                break
            case .ERROR_DB:
                break
            case .ERROR_USER_PAUSED:
                break
            case .ERROR_WRONG_PWD:
                Local.removeAutoLogin()
            default:
                self?.view.showToast(msg)
            }
            
//            if code == 205 {
            self?.openLogSingupView()
//            }
        })
    }
    
    func checkVersion() {
        changeLoadingViewVisiblity(isHidden: false)
        Rest.getVersionInfo(success: { [weak self] result -> Void in
            self?.changeLoadingViewVisiblity(isHidden: true)
            
            let version = result as! ModelVersion
            gReview = version.is_review
            if gReview {
                self?.SNSView.isHidden = true
            } else {
                self?.SNSView.isHidden = false
            }
            
            self?.onGetVersionSuccess(version)
        }, failure: { [weak self] _, _ in
            self?.changeLoadingViewVisiblity(isHidden: true)
            self?.openLogSingupView()
        })
    }
}

extension IntroVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == newIntroScrollView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            introCurrentPage = min(max(page, 0), introTotalPages - 1)
            updateIntroIndicator()
            updateIntroNavButtons()
        } else if scrollView == pageScrollView {
            let offset = scrollView.contentOffset.x
            onChangedPage(Int(offset / scrollView.frame.size.width) % pageCount)
        }
    }
}

extension IntroVC: SnsManagerDelegate {
    func snsAuthCompleted(_ me: SnsUserInfo) {
        var snsId = ""
        var type = 0
        switch me.user_login_type {
        case .Naver?:
            type = 2
            snsId = me.user_sns_id
        case .Kakao?:
            type = 5
            snsId = me.user_sns_id
        case .Facebook?:
            type = 3
            snsId = me.user_sns_id
        case .Google?:
            type = 1
            snsId = me.user_sns_id
        default:
            break
        }

        snsLogin(_id: snsId, _pwd: snsId, _type: type)
    }

    func snsAuthError(_ type: SnsType, msg: String) {
        view.showToast(msg)
    }
}

// MARK: - New 5-Page Intro + Permissions

extension IntroVC {
    
    private static let introIndicatorActive  = UIColor(red: 30.0/255.0, green: 49.0/255.0, blue: 157.0/255.0, alpha: 1)
    private static let introIndicatorInactive = UIColor(red: 212.0/255.0, green: 213.0/255.0, blue: 216.0/255.0, alpha: 1)
    private static let introTitleColor  = UIColor(red: 17.0/255.0, green: 17.0/255.0, blue: 17.0/255.0, alpha: 1)
    private static let introDescColor   = UIColor(red: 107.0/255.0, green: 108.0/255.0, blue: 110.0/255.0, alpha: 1)
    private static let introBtnColor    = UIColor(red: 30.0/255.0, green: 49.0/255.0, blue: 157.0/255.0, alpha: 1)
    private static let introBorderColor = UIColor(red: 235.0/255.0, green: 237.0/255.0, blue: 240.0/255.0, alpha: 1)
    
    func showNewIntro() {
        changeLoadingViewVisiblity(isHidden: true)
        introView.isHidden = true
        startView.isHidden = true
        
        let container = UIView()
        container.backgroundColor = .white
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.topAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        newIntroView = container
        
        let sv = UIScrollView()
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.bounces = false
        sv.delegate = self
        sv.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(sv)
        
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: container.topAnchor),
            sv.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            sv.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        newIntroScrollView = sv
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        sv.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: sv.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: sv.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: sv.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: sv.contentLayoutGuide.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: sv.frameLayoutGuide.heightAnchor),
            contentView.widthAnchor.constraint(equalTo: sv.frameLayoutGuide.widthAnchor, multiplier: CGFloat(introTotalPages))
        ])
        
        let pages = [
            buildIntroPage1(),
            buildIntroPage2(),
            buildIntroPage3(),
            buildIntroPage4(),
            buildIntroPage5()
        ]
        
        var prev: UIView? = nil
        for (i, page) in pages.enumerated() {
            page.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(page)
            NSLayoutConstraint.activate([
                page.topAnchor.constraint(equalTo: contentView.topAnchor),
                page.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                page.widthAnchor.constraint(equalTo: sv.frameLayoutGuide.widthAnchor)
            ])
            if let prev = prev {
                page.leadingAnchor.constraint(equalTo: prev.trailingAnchor).isActive = true
            } else {
                page.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            }
            if i == pages.count - 1 {
                page.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            }
            prev = page
        }
        
        introCurrentPage = 0
    }
    
    func hideNewIntro() {
        newIntroView?.removeFromSuperview()
        newIntroView = nil
        newIntroScrollView = nil
        indicatorDots = []
    }
    
    // MARK: Indicator & Navigation Helpers
    
    private func makeIndicator(activeIndex: Int) -> UIStackView {
        indicatorDots = []
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        for i in 0..<4 {
            let dot = UIView()
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: 8).isActive = true
            dot.heightAnchor.constraint(equalToConstant: 8).isActive = true
            dot.layer.cornerRadius = 4
            dot.backgroundColor = (i == activeIndex) ? IntroVC.introIndicatorActive : IntroVC.introIndicatorInactive
            stack.addArrangedSubview(dot)
            indicatorDots.append(dot)
        }
        return stack
    }
    
    func updateIntroIndicator() {
        for (i, dot) in indicatorDots.enumerated() {
            dot.backgroundColor = (i == introCurrentPage) ? IntroVC.introIndicatorActive : IntroVC.introIndicatorInactive
        }
    }
    
    func updateIntroNavButtons() {
    }
    
    private func makeTopBar(showBack: Bool) -> UIView {
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        let btnBack = UIButton(type: .system)
        btnBack.setImage(UIImage(systemName: "chevron.left")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)), for: .normal)
        btnBack.tintColor = IntroVC.introTitleColor
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        btnBack.addTarget(self, action: #selector(introPrevPage), for: .touchUpInside)
        btnBack.isHidden = !showBack
        bar.addSubview(btnBack)
        
        let btnClose = UIButton(type: .system)
        btnClose.setImage(UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)), for: .normal)
        btnClose.tintColor = IntroVC.introTitleColor
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        btnClose.addTarget(self, action: #selector(introSkipTapped), for: .touchUpInside)
        bar.addSubview(btnClose)
        
        NSLayoutConstraint.activate([
            btnBack.leadingAnchor.constraint(equalTo: bar.leadingAnchor, constant: 24),
            btnBack.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
            btnBack.widthAnchor.constraint(equalToConstant: 24),
            btnBack.heightAnchor.constraint(equalToConstant: 24),
            btnClose.trailingAnchor.constraint(equalTo: bar.trailingAnchor, constant: -24),
            btnClose.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
            btnClose.widthAnchor.constraint(equalToConstant: 24),
            btnClose.heightAnchor.constraint(equalToConstant: 24)
        ])
        return bar
    }
    
    private func makeBottomButton(title: String, action: Selector) -> UIView {
        let footer = UIView()
        footer.translatesAutoresizingMaskIntoConstraints = false
        footer.backgroundColor = .white
        
        let sep = UIView()
        sep.backgroundColor = IntroVC.introBorderColor
        sep.translatesAutoresizingMaskIntoConstraints = false
        footer.addSubview(sep)
        
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.backgroundColor = IntroVC.introBtnColor
        btn.layer.cornerRadius = 12
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: action, for: .touchUpInside)
        footer.addSubview(btn)
        
        NSLayoutConstraint.activate([
            sep.topAnchor.constraint(equalTo: footer.topAnchor),
            sep.leadingAnchor.constraint(equalTo: footer.leadingAnchor),
            sep.trailingAnchor.constraint(equalTo: footer.trailingAnchor),
            sep.heightAnchor.constraint(equalToConstant: 1),
            btn.topAnchor.constraint(equalTo: sep.bottomAnchor, constant: 12),
            btn.leadingAnchor.constraint(equalTo: footer.leadingAnchor, constant: 24),
            btn.trailingAnchor.constraint(equalTo: footer.trailingAnchor, constant: -24),
            btn.heightAnchor.constraint(equalToConstant: 56),
            btn.bottomAnchor.constraint(equalTo: footer.bottomAnchor, constant: -12)
        ])
        return footer
    }
    
    // MARK: Page Builders
    
    private func buildIntroPage1() -> UIView {
        let page = UIView()
        page.backgroundColor = .white
        
        let safeTop = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44
        
        let topBar = makeTopBar(showBack: false)
        page.addSubview(topBar)
        
        let indicator = makeIndicator(activeIndex: 0)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        page.addSubview(indicator)
        
        let titleLabel = UILabel()
        titleLabel.text = "Important documents are hard\nto find when you need them, right?"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = IntroVC.introTitleColor
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        page.addSubview(titleLabel)
        
        let imageView = UIImageView(image: UIImage(named: "img_intro_onboarding1"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        page.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: page.topAnchor, constant: safeTop),
            topBar.leadingAnchor.constraint(equalTo: page.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: page.trailingAnchor),
            
            indicator.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 24),
            indicator.centerXAnchor.constraint(equalTo: page.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: page.trailingAnchor, constant: -24),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: page.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: page.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: page.bottomAnchor)
        ])
        return page
    }
    
    private func buildOnboardingPage(activeIndex: Int, title: String, desc: String?, imageName: String) -> UIView {
        let page = UIView()
        page.backgroundColor = .white
        
        let safeTop = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44
        
        let topBar = makeTopBar(showBack: true)
        page.addSubview(topBar)
        
        let indicator = UIStackView()
        indicator.axis = .horizontal
        indicator.spacing = 6
        indicator.alignment = .center
        indicator.translatesAutoresizingMaskIntoConstraints = false
        for i in 0..<4 {
            let dot = UIView()
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: 8).isActive = true
            dot.heightAnchor.constraint(equalToConstant: 8).isActive = true
            dot.layer.cornerRadius = 4
            dot.backgroundColor = (i == activeIndex) ? IntroVC.introIndicatorActive : IntroVC.introIndicatorInactive
            indicator.addArrangedSubview(dot)
        }
        page.addSubview(indicator)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = IntroVC.introTitleColor
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        page.addSubview(titleLabel)
        
        var descBottom: NSLayoutYAxisAnchor = titleLabel.bottomAnchor
        var descBottomOffset: CGFloat = 40
        
        if let desc = desc {
            let descLabel = UILabel()
            descLabel.text = desc
            descLabel.font = UIFont.systemFont(ofSize: 16)
            descLabel.textColor = IntroVC.introDescColor
            descLabel.textAlignment = .center
            descLabel.numberOfLines = 0
            descLabel.translatesAutoresizingMaskIntoConstraints = false
            page.addSubview(descLabel)
            
            NSLayoutConstraint.activate([
                descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
                descLabel.leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 24),
                descLabel.trailingAnchor.constraint(equalTo: page.trailingAnchor, constant: -24)
            ])
            descBottom = descLabel.bottomAnchor
            descBottomOffset = 40
        }
        
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        page.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: page.topAnchor, constant: safeTop),
            topBar.leadingAnchor.constraint(equalTo: page.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: page.trailingAnchor),
            
            indicator.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 24),
            indicator.centerXAnchor.constraint(equalTo: page.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: page.trailingAnchor, constant: -24),
            
            imageView.topAnchor.constraint(equalTo: descBottom, constant: descBottomOffset),
            imageView.centerXAnchor.constraint(equalTo: page.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 220),
            imageView.heightAnchor.constraint(equalToConstant: 467)
        ])
        return page
    }
    
    private func buildIntroPage2() -> UIView {
        return buildOnboardingPage(
            activeIndex: 1,
            title: "Document Registration",
            desc: "Register documents directly with the TrayStorage app\nto record and manage them safely.",
            imageName: "img_intro_onboarding2"
        )
    }
    
    private func buildIntroPage3() -> UIView {
        return buildOnboardingPage(
            activeIndex: 2,
            title: "NFC Tag",
            desc: "Register documents on the NFC tag attached to TrayStorage,\nand your colleagues can also check the registered\ndocuments through the NFC tag.",
            imageName: "img_intro_onboarding3"
        )
    }
    
    private func buildIntroPage4() -> UIView {
        let page = buildOnboardingPage(
            activeIndex: 3,
            title: "Take the first step towards\nsmart document management\nwith TrayStorage.",
            desc: nil,
            imageName: "img_intro_onboarding4"
        )
        
        let footer = makeBottomButton(title: "Get Started", action: #selector(introStartTapped))
        page.addSubview(footer)
        
        let safeBottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        
        NSLayoutConstraint.activate([
            footer.leadingAnchor.constraint(equalTo: page.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: page.trailingAnchor),
            footer.bottomAnchor.constraint(equalTo: page.bottomAnchor, constant: -safeBottom)
        ])
        return page
    }
    
    private func buildIntroPage5() -> UIView {
        let page = UIView()
        page.backgroundColor = .white
        
        let safeTop = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 44
        let safeBottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        
        // Header
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        page.addSubview(header)
        
        let headerTitle = UILabel()
        headerTitle.text = "TrayStorage Permissions"
        headerTitle.font = UIFont.boldSystemFont(ofSize: 18)
        headerTitle.textColor = IntroVC.introTitleColor
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(headerTitle)
        
        let headerDesc = UILabel()
        headerDesc.text = "TrayStorage uses the following permissions.\nPlease allow permissions for smooth use of the service."
        headerDesc.font = UIFont.systemFont(ofSize: 14)
        headerDesc.textColor = IntroVC.introDescColor
        headerDesc.numberOfLines = 0
        headerDesc.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(headerDesc)
        
        NSLayoutConstraint.activate([
            headerTitle.topAnchor.constraint(equalTo: header.topAnchor),
            headerTitle.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            headerDesc.topAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 12),
            headerDesc.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            headerDesc.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            headerDesc.bottomAnchor.constraint(equalTo: header.bottomAnchor)
        ])
        
        // Permission scroll content
        let scrollContent = UIScrollView()
        scrollContent.translatesAutoresizingMaskIntoConstraints = false
        scrollContent.showsVerticalScrollIndicator = true
        page.addSubview(scrollContent)
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollContent.addSubview(contentStack)
        
        // Top separator
        let topSep = UIView()
        topSep.backgroundColor = IntroVC.introBorderColor
        topSep.translatesAutoresizingMaskIntoConstraints = false
        topSep.heightAnchor.constraint(equalToConstant: 1).isActive = true
        contentStack.addArrangedSubview(topSep)
        
        // "Required Permissions" label
        let requiredLabel = UILabel()
        requiredLabel.text = "Required Permissions"
        requiredLabel.font = UIFont.boldSystemFont(ofSize: 16)
        requiredLabel.textColor = IntroVC.introBtnColor
        requiredLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let requiredWrapper = UIView()
        requiredWrapper.translatesAutoresizingMaskIntoConstraints = false
        requiredWrapper.addSubview(requiredLabel)
        NSLayoutConstraint.activate([
            requiredLabel.topAnchor.constraint(equalTo: requiredWrapper.topAnchor, constant: 12),
            requiredLabel.leadingAnchor.constraint(equalTo: requiredWrapper.leadingAnchor),
            requiredLabel.bottomAnchor.constraint(equalTo: requiredWrapper.bottomAnchor)
        ])
        contentStack.addArrangedSubview(requiredWrapper)
        
        // Permission box: Camera
        contentStack.addArrangedSubview(
            makePermissionBox(sfSymbol: "camera.fill", title: "Camera", desc: "Provides document photo capture service")
        )
        
        // Permission box: Photo Library
        contentStack.addArrangedSubview(
            makePermissionBox(sfSymbol: "photo.fill.on.rectangle.fill", title: "Photos", desc: "Captured photos are saved and provides\ndocument photo attachment service")
        )
        
        // Bottom separator
        let bottomSep = UIView()
        bottomSep.backgroundColor = IntroVC.introBorderColor
        bottomSep.translatesAutoresizingMaskIntoConstraints = false
        bottomSep.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let bottomSepWrapper = UIView()
        bottomSepWrapper.translatesAutoresizingMaskIntoConstraints = false
        bottomSepWrapper.addSubview(bottomSep)
        NSLayoutConstraint.activate([
            bottomSep.topAnchor.constraint(equalTo: bottomSepWrapper.topAnchor, constant: 12),
            bottomSep.leadingAnchor.constraint(equalTo: bottomSepWrapper.leadingAnchor),
            bottomSep.trailingAnchor.constraint(equalTo: bottomSepWrapper.trailingAnchor),
            bottomSep.bottomAnchor.constraint(equalTo: bottomSepWrapper.bottomAnchor)
        ])
        contentStack.addArrangedSubview(bottomSepWrapper)
        
        // Note
        let noteLabel = UILabel()
        noteLabel.text = "• If there is a permission error, you can re-grant permissions by deleting and reinstalling the app."
        noteLabel.font = UIFont.systemFont(ofSize: 14)
        noteLabel.textColor = IntroVC.introDescColor
        noteLabel.numberOfLines = 0
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(noteLabel)
        
        // Footer button
        let footer = makeBottomButton(title: "Confirm", action: #selector(introConfirmTapped))
        page.addSubview(footer)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: page.topAnchor, constant: safeTop + 32),
            header.leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 24),
            header.trailingAnchor.constraint(equalTo: page.trailingAnchor, constant: -24),
            
            scrollContent.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 16),
            scrollContent.leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 24),
            scrollContent.trailingAnchor.constraint(equalTo: page.trailingAnchor, constant: -24),
            scrollContent.bottomAnchor.constraint(equalTo: footer.topAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollContent.contentLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollContent.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollContent.contentLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollContent.contentLayoutGuide.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollContent.frameLayoutGuide.widthAnchor),
            
            footer.leadingAnchor.constraint(equalTo: page.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: page.trailingAnchor),
            footer.bottomAnchor.constraint(equalTo: page.bottomAnchor, constant: -safeBottom)
        ])
        return page
    }
    
    private func makePermissionBox(sfSymbol: String, title: String, desc: String) -> UIView {
        let box = UIView()
        box.layer.borderWidth = 1
        box.layer.borderColor = IntroVC.introBorderColor.cgColor
        box.layer.cornerRadius = 8
        box.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView()
        icon.image = UIImage(systemName: sfSymbol)
        icon.tintColor = IntroVC.introTitleColor
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        box.addSubview(icon)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = IntroVC.introTitleColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        box.addSubview(titleLabel)
        
        let descLabel = UILabel()
        descLabel.text = desc
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = IntroVC.introDescColor
        descLabel.numberOfLines = 0
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        box.addSubview(descLabel)
        
        NSLayoutConstraint.activate([
            box.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),
            icon.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 16),
            icon.centerYAnchor.constraint(equalTo: box.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.topAnchor.constraint(equalTo: box.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: -16),
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: -16),
            descLabel.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: -16)
        ])
        return box
    }
    
    // MARK: Intro Actions
    
    @objc func introPrevPage() {
        guard introCurrentPage > 0 else { return }
        introCurrentPage -= 1
        let x = CGFloat(introCurrentPage) * (newIntroScrollView?.frame.width ?? 0)
        newIntroScrollView?.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        updateIntroIndicator()
    }
    
    @objc func introSkipTapped() {
        let ud = UserDefaults.standard
        ud.set(true, forKey: Local.PREFS_APP_INTRO_SKIP.rawValue)
        ud.synchronize()
        hideNewIntro()
        openLogSingupView()
    }
    
    @objc func introStartTapped() {
        introCurrentPage = 4
        let x = CGFloat(introCurrentPage) * (newIntroScrollView?.frame.width ?? 0)
        newIntroScrollView?.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        updateIntroIndicator()
    }
    
    @objc func introConfirmTapped() {
        requestAppPermissions()
    }
    
    // MARK: Permissions
    
    private func requestAppPermissions() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] _ in
            PHPhotoLibrary.requestAuthorization { _ in
                DispatchQueue.main.async {
                    self?.proceedAfterPermissions()
                }
            }
        }
    }
    
    private func proceedAfterPermissions() {
        let ud = UserDefaults.standard
        ud.set(true, forKey: Local.PREFS_APP_INTRO_SKIP.rawValue)
        ud.synchronize()
        hideNewIntro()
        openLogSingupView()
    }
}
