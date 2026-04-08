//
//  MenuVC.swift
//  Traystorage
//

import UIKit

protocol MenuDelegate {
    func openProfile()
    func openInvite()
    func openContactus()
    func openNotice()
    func openSetting()
}

class MenuVC: BaseVC {
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var vwMenu: UIView!
    @IBOutlet var vwMenus: [UIView]!
    @IBOutlet weak var vwAvatar: UIImageView!
    @IBOutlet weak var vwName: UILabel!
    @IBOutlet weak var leadingLayoutConstraint: NSLayoutConstraint!
    
    var delegate: MenuDelegate?
    let transitionTime = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
    }
    
    override func removeFromParent() {
        self.leadingLayoutConstraint.constant = 0

//        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: self.transitionTime, animations: {
                self.view.layoutIfNeeded()
                self.vwBg.alpha = 0
            }) { (_) in
                self.view.removeFromSuperview()
                self.dismiss(animated: true, completion: nil)
            }
//        })
    }
    
    func initVC() {
        for (index, menu) in vwMenus.enumerated() {
            menu.tag = index
            menu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickMenu(_:))))
        }
    }
    
    func slideOpen(_ superview : UIView) {
        
        self.view.frame = CGRect.init(x: 0, y: 0, width: superview.frame.size.width, height: superview.frame.size.height)
        superview.addSubview(self.view)

        let frame = vwMenu.frame
        self.leadingLayoutConstraint.constant = frame.width
        vwBg.alpha = 0

//        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: self.transitionTime) {
                self.view.layoutIfNeeded()
                self.vwBg.alpha = 0.2
            }
//        })
        
        let user = Rest.user!
        if let url = user.profile_img {
            vwAvatar.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "Icon-C-User-60")!)
        }
        vwName.text = user.name
    }
    
    private func contactUs() {
        
    }
    
    private func logout() {
        Local.deleteUser()
    }
    
    //
    // MARK: - Action
    //
    @IBAction func onClickClose(_ sender: Any) {
        removeFromParent()
    }
    
    @objc func onClickMenu(_ sender: UITapGestureRecognizer) {
        if delegate == nil {
            return;
        }
        
        switch sender.view?.tag {
        case 0:
            removeFromParent()
            delegate?.openProfile()
            break
        case 1:
            removeFromParent()
            delegate?.openInvite()
            break
        case 2:
            removeFromParent()
            delegate?.openContactus()
            break
        case 3:
            removeFromParent()
            delegate?.openNotice()
            break
        case 4:
            removeFromParent()
            delegate?.openSetting()
            break
        default:
            break
        }
    }
}
