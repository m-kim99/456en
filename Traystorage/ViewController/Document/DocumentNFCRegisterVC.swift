import CoreNFC
import Firebase
import FirebaseDynamicLinks
import UIKit
import SVProgressHUD

class DocumentNFCRegisterVC: BaseVC, NFCNDEFReaderSessionDelegate {
    var documentID = 0
    var documentCode = ""
    var dimLink = ""

    var session: NFCNDEFReaderSession?
    override func viewDidLoad() {
        super.viewDidLoad()

        getDimLink()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.startNFCScan()
//        }
    }

    func startNFCScan() {
        session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
        session?.begin()
    }

    @IBAction func onClickCacnel(_ sender: Any) {
        popVC()
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                if let string = String(data: record.payload, encoding: .ascii) {
                    print(string)
                }
            }
        }
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if tags.count > 1 {
            // Restart polling in 500 milliseconds.
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than 1 tag is detected. Please remove all tags and try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval) {
                session.restartPolling()
            }
            return
        }

        // Connect to the found tag and write an NDEF message to it.
        let tag = tags.first!
        session.connect(to: tag, completionHandler: { (error: Error?) in
            if error != nil {
                session.alertMessage = "Unable to connect to tag."
                session.invalidate()
                return
            }

            tag.queryNDEFStatus(completionHandler: { [self] (ndefStatus: NFCNDEFStatus, _: Int, error: Error?) in
                guard error == nil else {
                    session.alertMessage = "Unable to query the NDEF status of tag."
                    session.invalidate()
                    return
                }

                switch ndefStatus {
                case .notSupported:
                    session.alertMessage = "Tag is not NDEF compliant."
                    session.invalidate()
                case .readOnly:
                    session.alertMessage = "Tag is read only."
                    session.invalidate()
                case .readWrite:

//                    let message = NFCNDEFMessage(data: currentTime.data(using: .utf8)!)
//                    var message: NFCNDEFMessage = .init(records: [])

                    let uriPayloadFromString = NFCNDEFPayload.wellKnownTypeURIPayload(
                        string: dimLink // dim link
                    )!
//                    let uriPayloadFromURL = NFCNDEFPayload.wellKnownTypeURIPayload(
//                        url: URL(string: "www.apple.com")! // dim link
//                    )!

                    // 2
//                    let textPayload = NFCNDEFPayload.wellKnownTypeTextPayload(
//                        string: self.documentCode, // currentTime,
//                        locale: Locale(identifier: "en")
//                    )!

                    // 3
                    let customTextPayload = NFCNDEFPayload(
                        format: .nfcWellKnown,
                        type: "T".data(using: .utf8)!,
                        identifier: Data(),
                        payload: self.documentCode.data(using: .utf8)!
                    )
                    let message = NFCNDEFMessage(
                        records: [
//                            uriPayloadFromURL,
//                            textPayload,
                            customTextPayload,
                            uriPayloadFromString,
                        ]
                    )
                    tag.writeNDEF(message, completionHandler: { (error: Error?) in
                        if error != nil {
                            session.alertMessage = "Write NDEF message fail: \(error!)"
                        } else {
                            session.alertMessage = "The document has been registered with the NFC tag."
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.popVC()
                            }
                        }
                        session.invalidate()
                    })
                @unknown default:
                    session.alertMessage = "Unknown NDEF tag status."
                    session.invalidate()
                }
            })
        })
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }

    func getDimLink() {
        SVProgressHUD.show()
        let _url = String(format: "https://traystorageen.page.link/document/%d", documentID)

        guard let link = URL(string: _url) else { return }
        let dynamicLinksDomainURIPrefix = "https://traystorageen.page.link"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.us.traystorage")
        linkBuilder?.iOSParameters?.appStoreID = "6474948759"
        let info = DynamicLinkNavigationInfoParameters()
        info.isForcedRedirectEnabled = true
        linkBuilder?.navigationInfoParameters = info
        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.us.traystorage")

//        guard let longDynamicLink = linkBuilder?.url else { return }FIRDynamicLinkIOSParameters
//        print("The long URL is: \(longDynamicLink)")
//        dimLink = longDynamicLink.absoluteString
//        linkBuilder?.options = DynamicLinkComponentsOptions()
//        linkBuilder?.options!.pathLength = .short
        linkBuilder?.shorten { url, _, _ in
            // guard let url = url, error != nil else { return }
            SVProgressHUD.dismiss()
            print("The short URL is: \(url)")
            self.dimLink = url!.absoluteString
            self.startNFCScan()
        }
    }
}
