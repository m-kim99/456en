import CoreNFC
import UIKit

class DocumentNFCRegisterVC: BaseVC, NFCNDEFReaderSessionDelegate {
    @IBOutlet weak var btnCancel: UIButton!
    var documentID = 0
    var documentCode = ""
    var session: NFCNDEFReaderSession?

    override func viewDidLoad() {
        super.viewDidLoad()

        startNFCScan()
    }

    func startNFCScan() {
        session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
        session?.begin()
    }

    @IBAction func onClickCacnel(_ sender: Any) {
        popVC()
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // invalidateAfterFirstRead is false, so didDetect tags: is called instead
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than 1 tag is detected. Please remove all tags and try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval) {
                session.restartPolling()
            }
            return
        }

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
                    self.writeDocumentToTag(tag, session: session)
                @unknown default:
                    session.alertMessage = "Unknown NDEF tag status."
                    session.invalidate()
                }
            })
        })
    }

    private func writeDocumentToTag(_ tag: NFCNDEFTag, session: NFCNDEFReaderSession) {
        let dimLink = "traystorageen://document/\(self.documentID)"

        // Record 0: text/plain MIME with documentCode (matches Android)
        let codeData = self.documentCode.data(using: .utf8) ?? Data()
        let mimePayload = NFCNDEFPayload(
            format: .media,
            type: "text/plain".data(using: .utf8)!,
            identifier: Data(),
            payload: codeData
        )

        // Record 1: URI record (matches Android)
        guard let uriPayload = NFCNDEFPayload.wellKnownTypeURIPayload(string: dimLink) else {
            session.alertMessage = "Failed to create URL payload."
            session.invalidate()
            return
        }

        let records: [NFCNDEFPayload] = [mimePayload, uriPayload]
        let message = NFCNDEFMessage(records: records)

        tag.writeNDEF(message, completionHandler: { (error: Error?) in
            if let error = error {
                session.alertMessage = "NFC tag write failed: \(error.localizedDescription)"
            } else {
                session.alertMessage = "Document registered to the NFC tag successfully."
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.popVC()
                }
            }
            session.invalidate()
        })
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
}
