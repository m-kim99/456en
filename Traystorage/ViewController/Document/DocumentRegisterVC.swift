import UIKit
import SKPhotoBrowser
import SVProgressHUD

class DocumentRegisterVC: BaseVC {
    
    @IBOutlet weak var imageDocment: UIImageView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfTag: UITextField!
    @IBOutlet var imageGroup: UIStackView!
    
    @IBOutlet weak var tfDetail: UITextView!
    @IBOutlet weak var lblDetailPlaceHolder: UILabel!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var labelCollectionView: UICollectionView!
    
    @IBOutlet weak var btnAddImageMain: UIButton!
    @IBOutlet weak var btnAddImageSub: UIButton!
    @IBOutlet weak var btnAction: UIButton!
    
    var isNewDocument = false
    
    var newDocument = ModelDocument()
    var document: ModelDocument?
    
    let viewTagImageCollectionView = 1
    let viewTagTagCollectionView = 2
    let viewTagLabelCollectionView = 3
    
    let viewTagStartImage = 1000
    let viewTagStartTag = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        copyDocument(toOrigin: false)
        initVC()
    }
    
    private func initVC() {
        imageCollectionView.register(UINib(nibName: "item_image", bundle: nil), forCellWithReuseIdentifier: "cell")
        tagCollectionView.register(UINib(nibName: "item_tag", bundle: nil), forCellWithReuseIdentifier: "cell")
        labelCollectionView.register(UINib(nibName: "item_label", bundle: nil), forCellWithReuseIdentifier: "cell")
        NotificationCenter.default.addObserver(self, selector: #selector(imgPick(_:)), name: NSNotification.Name(rawValue: "image_pick"), object: nil)
        
        updateImageAddButtonAndCollectionView()
        
        tfTitle.text = newDocument.title
        tfDetail.text = newDocument.content
        updateDetailPlaceHolderVisible(newDocument.content)
        if isNewDocument {
            btnAction.setTitle("doc_reg"._localized, for: .normal)
        } else {
            btnAction.setTitle("save"._localized, for: .normal)
        }
        
        if gReview {
            imageGroup.isHidden = true
        } else {
            imageGroup.isHidden = false
        }
    }
    
    private func copyDocument(toOrigin: Bool) {
        guard let origDoc = document else {
            return
        }
        
        let newDoc = newDocument

        if toOrigin {
            origDoc.title = newDoc.title
            origDoc.content = newDoc.content
            origDoc.label = newDoc.label
            origDoc.reg_time = newDoc.reg_time
            origDoc.create_time = newDoc.create_time
            
            origDoc.tags.replaceSubrange(0..<origDoc.tags.count, with: newDoc.tags)
            origDoc.images.replaceSubrange(0..<origDoc.images.count, with: newDoc.images)
        } else {
            newDoc.doc_id = origDoc.doc_id
            newDoc.user_id = origDoc.user_id
            newDoc.title = origDoc.title
            newDoc.content = origDoc.content
            newDoc.label = origDoc.label
            newDoc.create_time = origDoc.create_time
            newDoc.reg_time = origDoc.reg_time
            
            newDoc.tags.replaceSubrange(0..<newDoc.tags.count, with: origDoc.tags)
            newDoc.images.replaceSubrange(0..<newDoc.images.count, with: origDoc.images)
        }
    }
    
    private func checkIsModified() -> Bool {
        guard let origDoc = document else {
            return !newDocument.title.isEmpty || !newDocument.content.isEmpty || !newDocument.tags.isEmpty || !newDocument.images.isEmpty || newDocument.label != 0
        }
        let newDoc = newDocument
        return newDoc.title != origDoc.title || newDoc.content != origDoc.content || newDoc.label != origDoc.label || newDoc.tags.count != origDoc.tags.count || newDoc.tags != origDoc.tags ||  newDoc.images.count != origDoc.images.count || !newDoc.images.elementsEqual(origDoc.images, by: { element1, element2 in
            return element1.elementsEqual(element2) { dic1, dic2 in
                if let val1 = dic1.value as? String, let val2 = dic2.value as? String {
                    return val1 == val2
                }
                return false
            }
        })
    }
    
    private func onDocumentAddSuccess(doc: ModelDocument!) {
        copyDocument(toOrigin: true)

        if let popDelegate = popDelegate {
            popDelegate.onWillBack("insert", doc)
        }
        
        let detailVC = DocumentDetailVC(nibName: "vc_document_detail", bundle: nil)
        detailVC.documentId = doc.doc_id
        detailVC.isAppearFromAddDoc = true
        self.pushVC(detailVC, animated: true)
    }
    
    private func onDocumentEditSuccess(doc: ModelDocument!) {
        copyDocument(toOrigin: true)
        if let popDelegate = self.popDelegate {
            popDelegate.onWillBack("update", doc)
        }
        popVC()
    }

    @IBAction func onClickRegister(_ sender: Any) {
        hideKeyboard()

        let doc = newDocument
        if doc.title.isEmpty {
            self.view.showToast("doc_title_empty"._localized)
            return
        }
        
        if doc.content.isEmpty {
            self.view.showToast("doc_content_empty"._localized)
            return
        }

        if doc.tags.count < 1 {
            self.view.showToast("doc_tag_empty"._localized)
            return
        }

        documentImageUpload()
    }

    @IBAction func onClickAddImage(_ sender: Any) {
        let vc = GalleryViewController(nibName: "vc_gallery", bundle: nil)
        self.pushVC(vc, animated: true)
    }
    
    @IBAction func onClickAddTag(_ sender: Any) {
        guard let tagText = tfTag.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), !tagText.isEmpty else {
            self.view.showToast("doc_tag_empty"._localized)
            return
        }
        
        let doc = newDocument
        
        if doc.tags.count < 5 {
            if doc.tags.contains(tagText) {
                hideKeyboard()
                self.view.showToast("doc_duplicated_tag"._localized)
            } else {
                doc.tags.insert(tagText, at: 0)
                tagCollectionView.reloadData()
                tfTag.text = nil
                let bottomRect = CGRect(origin: CGPoint(x: 0, y: self.keyboardAvoidScroll?.contentSize.height ?? 0), size: CGSize(width: 1, height: 1))
                self.keyboardAvoidScroll?.scrollRectToVisible(bottomRect, animated: true)
            }
        } else {
            hideKeyboard()
            self.view.showToast("doc_tag_limit_5"._localized)
        }
    }
    
    override func hideKeyboard() {
        tfTitle.resignFirstResponder()
        tfTag.resignFirstResponder()
        tfDetail.resignFirstResponder()
    }
    
    override func onBackProcess(_ viewController: UIViewController) {
        if !checkIsModified() {
            super.onBackProcess(viewController)
            return
        }
        
        ConfirmDialog.show(self, title: "doc_discard_title"._localized, message: "doc_discard_desc"._localized, showCancelBtn: true) { [weak self] () -> Void in
            self?.popVC()
        }
    }
    
    private func updateDetailPlaceHolderVisible(_ detail: String) {
        lblDetailPlaceHolder.isHidden = !detail.isEmpty
    }
    
    @objc func imgPick(_ notification : Notification) {
        let imgList = notification.object as! [UIImage]
        
        for image in imgList {
            newDocument.addImage(image: image)
        }
        self.imageCollectionView.reloadData()
        self.updateImageAddButtonAndCollectionView()
    }
    
    private func updateImageAddButtonAndCollectionView() {
        let noImage = newDocument.images.isEmpty
        btnAddImageMain.isHidden = !noImage
        btnAddImageSub.isHidden = noImage
        imageCollectionView.isHidden = noImage
    }
    
    private func documentImageUpload() {
        let doc = newDocument
        
        var files:[Data] = []
        var imageURLs: [String] = []
        for item in doc.images {
            if let img = item["image"] as? UIImage {
                let data = img.jpegData(compressionQuality: 0.5)!
                files.append(data);
            } else if let urlString = item["url"] as? String, let url = URL(string: urlString) {
                imageURLs.append(url.lastPathComponent)
            }
        }
        
        if files.count > 0 {
            LoadingDialog.show()
            Rest.uploadFiles(files: files) { [weak self](result) in
                LoadingDialog.dismiss()
                
                let fileList = result as! ModelUploadFileList
                imageURLs.append(contentsOf: fileList.fileNames)
                
                let images = imageURLs.joined(separator: ",")
                
                self?.documentEditDone(images: images)

            } failure: { [weak self](_, err) in
                LoadingDialog.dismiss()
                self?.view.showToast(err)
            }
        } else {
            let images = imageURLs.joined(separator: ",")

            documentEditDone(images: images)
        }
    }
    
    private func documentEditDone(images: String) {
        let doc = newDocument

        LoadingDialog.show()
        if isNewDocument {
            Rest.documentInsert(title: doc.title, content: doc.content, label: doc.label, tags: doc.tags.joined(separator: ","), images: images) { [weak self](result) in
                LoadingDialog.dismiss()
                let addedDoc = result as! ModelDocument
                doc.doc_id = addedDoc.doc_id
                doc.reg_time = addedDoc.reg_time
                self?.onDocumentAddSuccess(doc: addedDoc)
            } failure: { [weak self](_, err) in
                LoadingDialog.dismiss()
                self?.view.showToast(err)
            }
        } else {
            Rest.documentUpdate(id: doc.doc_id.description, title: doc.title, content: doc.content, label: doc.label, tags: doc.tags.joined(separator: ","), images: images, success: { [weak self] (result) in
                LoadingDialog.dismiss()
                self?.onDocumentEditSuccess(doc: doc)
            }) {[weak self](_, err) in
                LoadingDialog.dismiss()
                self?.view.showToast(err)
            }
        }
    }
    
    @IBAction func onClickClear(_ sender: UIButton) {
        guard let superView = sender.superview else {
            return
        }
        
        let viewTag = superView.tag
        let doc = newDocument
        if viewTag >= viewTagStartTag {
            let index = viewTag - viewTagStartTag
            doc.tags.remove(at: index)
            tagCollectionView.reloadData()
            self.view.showToast("doc_tag_deleted"._localized)
        } else {
            let index = viewTag - viewTagStartImage
            doc.removeImage(at: index)
            imageCollectionView.reloadData()
            updateImageAddButtonAndCollectionView()
        }
    }
    
    @IBAction func onTitleChanged(_ sender: UITextField) {
        newDocument.title = sender.text ?? ""
    }
}

extension DocumentRegisterVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateDetailPlaceHolderVisible(textView.text ?? "")
        newDocument.content = textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLen = (textView.text?.count ?? 0) - range.length + text.count
        return newLen <= 200
    }
}

extension DocumentRegisterVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLen = (textField.text?.count ?? 0) - range.length + string.count

        if textField == tfTitle, newLen > 30 {
            return false
        }
        if textField == tfTag, newLen > 10 {
            return false
        }
        
        return true
    }
}


extension DocumentRegisterVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewTag = collectionView.tag
        let doc = newDocument
        switch collectionViewTag {
        case viewTagTagCollectionView:
            let strTitle = doc.tags[indexPath.row]
            let width = strTitle.widthToFit(36, AppFont.appleGothicNeoRegular(16))
            return CGSize(width: width + 52, height: 36)
        default:
            break
        }
        return (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collectionViewTag = collectionView.tag
        let doc = newDocument
        switch collectionViewTag {
        case viewTagImageCollectionView:
            return doc.images.count
        case viewTagTagCollectionView:
            return doc.tags.count
        case viewTagLabelCollectionView:
            return 10
        default:
            break
        }

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let collectionViewTag = collectionView.tag
        let doc = newDocument
        let index = indexPath.row
        switch collectionViewTag {
        case viewTagImageCollectionView:
            if let imageView = cell.viewWithTag(2) as? UIImageView {
                doc.setToImageView(at: index, imageView: imageView)
            }
            break
        case viewTagTagCollectionView:
            if let titleLabel = cell.viewWithTag(1) as? UILabel {
                titleLabel.text = doc.tags[indexPath.row]
            }
            break
        case viewTagLabelCollectionView:
            if let outLineView = cell.viewWithTag(20) {
                outLineView.borderWidth = doc.label == indexPath.row ? 1 : 0
            }
            
            if let labelColorView = cell.viewWithTag(21) {
                labelColorView.backgroundColor = AppColor.labelColors[indexPath.row]
                labelColorView.borderColor = .black
                if indexPath.row == 0 {
                    labelColorView.borderWidth = 1.0
                } else {
                    labelColorView.borderWidth = 0
                }
            }
            break
        default:
            break
        }
        
        if let closeButton = cell.viewWithTag(10) as? UIButton {
            if let contentView = closeButton.superview {
                let newTagStart = collectionViewTag == viewTagImageCollectionView ? viewTagStartImage : viewTagStartTag
                contentView.tag = newTagStart + indexPath.row
            }
            closeButton.removeTarget(self, action: #selector(self.onClickClear(_:)), for: .touchUpInside)
            closeButton.addTarget(self, action: #selector(self.onClickClear(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collectionViewTag = collectionView.tag
        let doc = newDocument
        switch collectionViewTag {
        case viewTagImageCollectionView:
            
            break
        case viewTagTagCollectionView:
            break
        case viewTagLabelCollectionView:
            doc.label = indexPath.row
            labelCollectionView.reloadData()
            break
        default:
            break
        }
    }
}
