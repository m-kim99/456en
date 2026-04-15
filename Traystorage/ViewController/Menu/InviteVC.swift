//
//  InviteVC.swift
//  Traystorage
//

import Foundation

class InviteVC: BaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initVC()
        addHeaderSeparator()
    }

    override func removeFromParent() {}

    func initVC() {}

    @IBAction func onClickInvite(_ sender: Any) {
        let appInstallUrl = "http://itunes.apple.com/app/id6474948759?mt=8"
        let content = "Do you need document management?\nSolved perfectly with Traystorage!\nInstall the Traystorage app now\nand easily manage your documents."

        // text to share
        let text = content + "\n\n" + appInstallUrl
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        self.present(activityViewController, animated: true, completion: nil)
    }
}
