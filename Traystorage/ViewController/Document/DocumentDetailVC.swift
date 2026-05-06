import ImageSlideshow
import Kingfisher
import PullToRefresh
import SKPhotoBrowser
import SVProgressHUD
import UIKit
import WebKit

class DocumentDetailVC: BaseVC {
    @IBOutlet var lblChallengeName: UILabel!
    
    private var imageList: [UIImage] = []
    private var pageNo = 0
    private var isLast = false
    
    @IBOutlet var imageCollectionView: UICollectionView!
    @IBOutlet var tagView: UILabel!
    
    @IBOutlet var documentTitle: UILabel!
    @IBOutlet var documentContent: UILabel!
    @IBOutlet var documentDate: UILabel!
    @IBOutlet var documentLabel: UIView!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnEdit: UIFontButton!
    @IBOutlet var btnNFCRegister: UIFontButton!
    @IBOutlet var vwEmptyTag: UIView!
    
    public var documentId: Int! = 0
    
    let viewTagImageCollectionView = 1
    let viewTagTagCollectionView = 2
    
    var isAppearFromAddDoc = false
    var isUpdated = false
    
    private var refreshControl = UIRefreshControl()
    private var document: ModelDocument?
    private var photoBrowser: SKPhotoBrowser!
    private var coupangBanner: CoupangAdBanner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCoupangBanner()
        setupDeleteButton()
        
        if isAppearFromAddDoc {
            view.showToast("doc_add_success_toast"._localized)
        }
        vwEmptyTag.isHidden = true
        loadContentsFormDoc()
        loadDocumentDetail(documentId)
        
        imageCollectionView.register(UINib(nibName: "item_image", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    private func setupDeleteButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        btnDelete.setImage(UIImage(systemName: "trash", withConfiguration: config), for: .normal)
        btnDelete.tintColor = UIColor(red: 30/255.0, green: 49/255.0, blue: 157/255.0, alpha: 1)
    }
    
    private func setupCoupangBanner() {
        guard let buttonStackView = btnEdit.superview,
              let mainStackView = buttonStackView.superview as? UIStackView else { return }
        
        coupangBanner = CoupangAdBanner(frame: .zero)
        coupangBanner.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(coupangBanner)
        
        NSLayoutConstraint.activate([
            coupangBanner.heightAnchor.constraint(equalToConstant: 210)
        ])
        
        mainStackView.setCustomSpacing(16, after: buttonStackView)
    }
    
    private func loadContentsFormDoc() {
        if let document = document {
            documentTitle.text = document.title
            documentContent.text = document.content
            documentDate.text = document.reg_time
            documentLabel.backgroundColor = AppColor.labelColors[document.label]
            documentLabel.borderColor = .black
            if document.label == 0 {
                documentLabel.borderWidth = 1.0
            } else {
                documentLabel.borderWidth = 0
            }

            if document.tags.isEmpty {
                tagView.text = nil
            } else {
                tagView.text = "#" + document.tags.joined(separator: " #")
            }
            
            let isVisible = document.user_id == Rest.user.id
            btnDelete.isHidden = !isVisible
            btnEdit.isHidden = !isVisible
            btnNFCRegister.isHidden = !isVisible

        } else {
            documentTitle.text = nil
            documentContent.text = nil
            documentDate.text = nil
            documentLabel.backgroundColor = nil
            tagView.text = nil
        }
        
        imageCollectionView.reloadData()
    }
    
    override func onBackProcess(_ viewController: UIViewController) {
        guard let vcs = navigationController?.viewControllers else {
            return
        }
        
        for vc in vcs {
            if vc is MainVC {
                navigationController?.popToViewController(vc, animated: true)

                if isUpdated, let mainVC = vc as? MainVC {
                    mainVC.onWillBack("update", document?.doc_id)
                }

                break
            }
        }
    }

    //

    // MARK: - ACTION

    //
    @IBAction func onClickTrash(_ sender: Any) {
        let docID = document?.doc_id
        ConfirmDialog.show2(self, title: "doc_del_query_title"._localized, message: "doc_del_query_desc"._localized, showCancelBtn: true) { [weak self] () -> Void in
            self?.deleteDocument(docID)
        }
    }

    @IBAction func onClickEdit(_ sender: Any) {
        let editVC = DocumentRegisterVC(nibName: "vc_document_register", bundle: nil)
        editVC.document = document
        editVC.popDelegate = self
        pushVC(editVC, animated: true, params: params)
    }
    
    @IBAction func onClickNFCRegister(_ sender: Any) {
        let vc = DocumentNFCRegisterVC(nibName: "vc_document_nfc_register", bundle: nil)
        vc.documentID = document!.doc_id
        vc.documentCode = document!.code1
        pushVC(vc, animated: true)
    }
    
    @IBAction func onClickGoMain(_ sender: Any) {
        popVC()
    }
}

//

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension DocumentDetailVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let doc = document else {
            return 0
        }
        return doc.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let closeButton = cell.viewWithTag(10) as? UIButton {
            closeButton.removeFromSuperview()
        }

        if let contentView = cell.viewWithTag(5) {
            contentView.backgroundColor = UIColor.clear
        }
        
        let index = indexPath.row
        
        let document = self.document!
        
        if let imageView = cell.viewWithTag(2) as? UIImageView {
            document.setToImageView(at: index, imageView: imageView)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = ImageSlideViewVC(nibName: "vc_image_browser", bundle: nil)
//        vc.modelDocument = self.document!
//        self.navigationController?.pushViewController(vc, animated: true)
        
        SKPhotoBrowserOptions.swapCloseAndDeleteButtons = true
        SKPhotoBrowserOptions.displayAction = false
        SKPhotoBrowserOptions.displayCounterLabel = true
        SKPhotoBrowserOptions.displayBackAndForwardButton = false
        SKButtonOptions.closeButtonPadding.y = view.safeAreaInsets.top
        SKToolbarOptions.font = AppFont.appleGothicNeoRegular(15)
        
        let modelDocument = document!
        
        var images = [SKPhoto]()
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for item in modelDocument.images {
                if let url = item["url"] as? String {
                    let url = URL(string: url)
                    let data = try? Data(contentsOf: url!)
                    let img = UIImage(data: data!)
                    images.append(SKPhoto.photoWithImage(img!))
                    // images.append(SKPhoto.photoWithImageURL(url))
                } else if let image = item["image"] as? UIImage {
                    images.append(SKPhoto.photoWithImage(image))
                }
            }
            SVProgressHUD.dismiss()
            self.photoBrowser = SKPhotoBrowser(photos: images)
            self.photoBrowser.delegate = self
            self.navigationController?.pushViewController(self.photoBrowser, animated: true)
        }
    }
}

extension DocumentDetailVC: SKPhotoBrowserDelegate {
    func didDismissAtPageIndex(_ index: Int) {
        popVC()
    }
}

////
//
//// MARK: - Navigation
//
////
// extension ChallengeDetailVC: BaseNavigation {
//    private func goVideoDetail(model: ModelVideo) {
//        let params = ["videoUid": model.video_uid]
//        pushVC(VideoDetailVC(nibName: "vc_video_detail", bundle: nil), animated: true, params: params as [String : Any])
//    }
// }
//
////
//
//// MARK: - RestApi
//
////
extension DocumentDetailVC: BaseRestApi {
    func loadDocumentDetail(_ document_uid: Int!) {
        LoadingDialog.show()
        Rest.documentDetail(documentID: document_uid, success: { [weak self] result -> Void in
            LoadingDialog.dismiss()
            self?.document = (result as! ModelDocument)
            self?.loadContentsFormDoc()
        }) { [weak self] code, err -> Void in
            LoadingDialog.dismiss()
            if code == 401 {
                self?.vwEmptyTag.isHidden = false
                self?.btnDelete.isHidden = true
                if let self = self {
                    AlertDialog.show(self, title: "empty_nfc_tag"._localized, message: "", okAction: {
                        self.popVC()
                    })
                }
            } else {
                self?.view.showToast(err)
            }
        }
    }
    
    func deleteDocument(_ docID: Int!) {
        LoadingDialog.show()
        Rest.documentDelete(id: docID.description, success: { [weak self] _ -> Void in
            LoadingDialog.dismiss()
            if let popDelegate = self?.popDelegate {
                popDelegate.onWillBack("delete", docID)
            }
            self?.popVC()
        }, failure: { _, err -> Void in
            LoadingDialog.dismiss()
            self.view.showToast(err)
        })
    }

//    func loadVideoList(page: Int) {
//        if (!refreshControl.isRefreshing) {
//            LoadingDialog.show()
//        }
//
//        self.pageNo = page
//        Rest.videoList(page: page, challenge_uid: challenge?.challenge_uid, user_uid: nil, success: { (result) -> Void in
//            LoadingDialog.dismiss()
//            let model = result as! ModelVideoList
//            if self.pageNo == 0 {
//                self.videoList.removeAll()
//            }
//
//            self.isLast = model.is_last
//
//            for i in 0 ..< model.list.count {
//                self.videoList.append(model.list[i]!)
//            }
//
//            self.tvChallenge.reloadData()
//            self.refreshControl.endRefreshing()
//        }, failure: { (_, err) -> Void in
//            LoadingDialog.dismiss()
//            self.view.showToast(err)
//        })
//    }
}

extension DocumentDetailVC: PopViewControllerDelegate {
    func onWillBack(_ sender: String, _ result: Any?) {
        if sender == "update" {
            loadContentsFormDoc()
            isUpdated = true
        }
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }.resume()
    }

    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
