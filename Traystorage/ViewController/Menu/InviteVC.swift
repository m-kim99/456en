//
//  InviteVC.swift
//  Traystorage
//

import UIKit

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
        let content = "Need a better way to manage your documents?\nTry Traystorage!\nDownload the app now and start organizing your documents with ease."

        // text to share
        let text = content + "\n\n" + appInstallUrl
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        self.present(activityViewController, animated: true, completion: nil)
    }
}
