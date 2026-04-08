//
//  LoadingDialog.swift
//  Traystorage
//
//  Created by Dev2 on 2021. 12. 15..
//

import UIKit
import WebKit
import SVProgressHUD

class LoadingDialog: UIViewController {
    @IBOutlet weak var vwRoot: UIView!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var loadingImage1: UIImageView!
    @IBOutlet weak var loadingImage2: UIImageView!
    @IBOutlet weak var loadingImage3: UIImageView!

    public typealias Callback = () -> Void
    
    var loadingImageOffset = 0
    var loadingImages: [UIImage] = []
    var loadingProgressTimer: Timer?	
    var controllerCount: Int = 0
    var controller: UIViewController? = nil

    static var sLoadingDialog : LoadingDialog! = nil
    static var sActiveController: UIViewController?
    
    
    static func setActiveController(_ viewController: UIViewController?) {
        if let vc = viewController {
            sActiveController = vc
        }
    }
    
    static func sharedDialog() -> LoadingDialog! {
        if sLoadingDialog == nil {
            sLoadingDialog = LoadingDialog("dialog_loading")
            sLoadingDialog.modalPresentationStyle = .overCurrentContext
            sLoadingDialog.modalTransitionStyle = .crossDissolve
        }
        return sLoadingDialog
    }
    
    static func show() {
        let dialog = sharedDialog()!;
        if let controller = dialog.controller, controller != sActiveController {
            dialog.onClose("")
        }
        
        if dialog.controllerCount <= 0 {
            dialog.controllerCount = 0
        }
        
        if let vc = sActiveController {
            dialog.controllerCount += 1
            if dialog.controllerCount == 1 {
                vc.present(sLoadingDialog, animated: false, completion: nil)
            }
        }
    }
    
    static func dismiss() {
        guard let popup = sLoadingDialog else {
            return
        }
        if popup.controllerCount >= 0 {
            popup.controllerCount -= 1
        }
        if popup.controllerCount == 0 {
            popup.onClose("")
        }
    }
    
    convenience init(_ nibName: String?) {
        self.init(nibName: nibName, bundle: nil)
        
        loadingImages.append(UIImage(named: "loading1")!)
        loadingImages.append(UIImage(named: "loading2")!)
        loadingImages.append(UIImage(named: "loading3")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startLoadingProgressTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopLoadingProgressTimer()
    }
    
    func initVC() {
        //vwBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onClose(_:))))
        vwRoot.frame = UIScreen.main.bounds
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func advanceLoaddingImage() {
        loadingImageOffset += 1
        loadingImageOffset %= 3
        
        loadingImage1.image = loadingImages[loadingImageOffset % 3]
        loadingImage2.image = loadingImages[(loadingImageOffset + 1) % 3]
        loadingImage3.image = loadingImages[(loadingImageOffset + 2) % 3]
    }
    
    func changeLoadingViewVisiblity(isHidden: Bool) {
        if isHidden {
            stopLoadingProgressTimer()
        } else {
            startLoadingProgressTimer()
        }
    }
    
    func startLoadingProgressTimer() {
        stopLoadingProgressTimer()
        
        self.loadingProgressTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: {[weak self] timer in
            self?.advanceLoaddingImage()
        })
    }
    
    func stopLoadingProgressTimer() {
        if let timer = loadingProgressTimer {
            timer.invalidate()
            loadingProgressTimer = nil
        }
    }
    //
    // MARK: - Action
    //
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: false) {
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}
