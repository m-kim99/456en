import ActionSheetController
import Photos
import SVProgressHUD
import UIKit

class MyProfileVC: BaseVC {
    @IBOutlet var vwAvatar: UIImageView!
    @IBOutlet var btnAddAvatar: UIButton!
    @IBOutlet var vwNameLabelGroup: UIStackView!
    @IBOutlet var labelName: UILabel!

    @IBOutlet var editName: UITextField!
    @IBOutlet var btnNameClear: UIButton!

    @IBOutlet var birthdayEdit: UITextField!
    @IBOutlet var birthdayButton: UIButton!
    @IBOutlet var birthdayArrow: UIImageView!
    @IBOutlet var emailEdit: UITextField!
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    private var headerEditButton: UIButton!
    
    var gender: Int = 0
    var avatarImage: UIImage?
    var avatarImageURL: String?
    var avatarImageName: String? // used to send "api"
    
    var isModified: Bool! = false
    
    private lazy var user: ModelUser = {
        return Rest.user
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        updateGender()
        setupHeaderEditButton()
        addHeaderSeparator()
        updateEditState(false)
    }
    
    
    func initVC() {
        editName.delegate = self
        avatarImageURL = user.profile_img
        if let avatarUrl = URL(string:avatarImageURL ?? "") {
            avatarImageName = avatarUrl.lastPathComponent
            vwAvatar.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "Icon-C-User-60")!)
        }

        labelName.text = user.name
        editName.text = user.name
        btnNameClear.isHidden = true
        birthdayEdit.text = user.birthday.replaceAll("-", with: ".")
        emailEdit.text = user.email

        gender = user.gender
        updateGender()
        
        NotificationCenter.default.addObserver(self, selector: #selector(imgPick(_:)), name: NSNotification.Name(rawValue: "image_pick"), object: nil)
    }
    
    override func hideKeyboard() {
        editName.resignFirstResponder()
        birthdayEdit.resignFirstResponder()
        emailEdit.resignFirstResponder()
    }
    
    private func updateEditState(_ isNameEditing: Bool) {
        btnAddAvatar.isHidden = !isNameEditing
        
        vwNameLabelGroup.isHidden = isNameEditing
        editName.isHidden = !isNameEditing
        btnNameClear.isHidden = !isNameEditing
        labelName.isHidden = isNameEditing

        birthdayEdit.isEnabled = isNameEditing
        birthdayButton.isEnabled = isNameEditing
        birthdayArrow.isHidden = !isNameEditing
        emailEdit.isEnabled = isNameEditing
        maleButton.isUserInteractionEnabled = isNameEditing
        femaleButton.isUserInteractionEnabled = isNameEditing
        saveButton.isEnabled = isNameEditing
        saveButton.isHidden = !isNameEditing
        
        if headerEditButton != nil {
            headerEditButton.setTitle(isNameEditing ? "Done" : "Edit", for: .normal)
        }
    }
    
    private func setupHeaderEditButton() {
        headerEditButton = UIButton(type: .system)
        headerEditButton.setTitle("Edit", for: .normal)
        headerEditButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        headerEditButton.setTitleColor(UIColor(red: 30.0/255.0, green: 49.0/255.0, blue: 157.0/255.0, alpha: 1), for: .normal)
        headerEditButton.addTarget(self, action: #selector(onToggleEditMode), for: .touchUpInside)
        headerEditButton.translatesAutoresizingMaskIntoConstraints = false
        
        guard let safeAreaRoot = view.subviews.first(where: { $0.translatesAutoresizingMaskIntoConstraints == false }),
              let headerView = safeAreaRoot.subviews.first(where: { $0.translatesAutoresizingMaskIntoConstraints == false }) else { return }
        
        headerView.addSubview(headerEditButton)
        NSLayoutConstraint.activate([
            headerEditButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerEditButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerEditButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func onToggleEditMode() {
        if saveButton.isEnabled {
            onSave(headerEditButton as Any)
        } else {
            updateEditState(true)
            editName.becomeFirstResponder()
            headerEditButton.setTitle("Done", for: .normal)
        }
    }
    
    private func updateGender() {
        let maleColor = gender == 0 ? AppColor.active : AppColor.gray
        let femaleColor = gender == 1 ? AppColor.active : AppColor.gray
        
        maleButton.borderColor = maleColor
        maleButton.tintColor = maleColor
        femaleButton.borderColor = femaleColor
        femaleButton.tintColor = femaleColor
    }
    
    @objc func imgPick(_ notification : Notification) {
        let imgList = notification.object as! [UIImage]
        let image = imgList[0]
        avatarImage = image
        vwAvatar.image = image
        isModified = true
    }
    
    private func onUploadedAvatar(url: String, name: String) {
        avatarImageURL = url
        avatarImage = nil
        avatarImageName = name
        
        onSave("")
    }
    
    override func onBackProcess(_ viewController: UIViewController) {
        if !isModified {
            super.onBackProcess(viewController)
            return
        }
        ConfirmDialog.show(self, title: "profile_discard_title"._localized, message: "profile_discard_desc"._localized, showCancelBtn: true) { [weak self] () -> Void in
            self?.popVC()
        }
    }
    
    @IBAction func onChangeAvatar(_ sender: Any) {
        let vc = GalleryViewController(nibName: "vc_gallery", bundle: nil)
        vc.multi = 0
        self.pushVC(vc, animated: true)
    }
    
    @IBAction func onEditName(_ sender: Any) {
        updateEditState(true)
        editName.becomeFirstResponder()
    }
    
    @IBAction func onSave(_ sender: Any) {
        hideKeyboard()
        
        guard let name = editName.text, !name.isEmpty else {
            self.view.showToast("empty_name_toast"._localized)
            return
        }
        
        guard let email = emailEdit.text, email.isEmpty || Validations.email(email) else {
            self.view.showToast("invalid_email_toast"._localized)
            return
        }
        
        if let image = avatarImage {
            uploadProfileImage(image: image)
            return
        }
        
        let birthday = self.birthdayEdit.text ?? ""
        
        ConfirmDialog.show(self, title: "profile_save"._localized, message: "", showCancelBtn: true) { [weak self] in
            self?.updateProfile(name: name, birthDay: birthday, email: email, gender: self?.gender ?? 0, profileImage:self?.avatarImageName ?? "")
        }
    }
    
    @IBAction func textDidChanged(_ sender: UITextField) {
        if sender == editName {
            guard let name = editName.text, !name.isEmpty else {
                btnNameClear.isHidden = true
                return
            }
            
            btnNameClear.isHidden = false
        }
    }
    @IBAction func onEditNameDidEnd(_ sender: UITextField!) {
        isModified = isModified || user.name != sender.text
    }
    
    @IBAction func onEditNameClear(_ sender: Any) {
        editName.text = nil
        btnNameClear.isHidden = true
    }
    
    @IBAction func onClickGender(_ sender: Any) {
        if let button = sender as? UIButton {
            if button == maleButton {
                gender = 0
            } else if button == femaleButton {
                gender = 1
            }
            updateGender()
            isModified = isModified || user.gender != gender
        }
    }
    
    @IBAction func onClickBirthDay(_ sender: Any) {
        hideKeyboard()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let birthday = dateFormatter.date(from: birthdayEdit.text ?? "")
        DatepickerDialog.show(self, date:birthday) { [weak self](date) in
            self?.birthdayEdit.text = dateFormatter.string(from: date)
            self?.isModified = (self?.isModified)! || self?.user.birthday != self?.birthdayEdit.text
        }
    }
}

extension MyProfileVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLen = (textField.text?.count ?? 0) - range.length + string.count

        if textField == editName, newLen > 50 {
            return false
        }
        
        if textField == emailEdit, newLen > 30 {
            return false
        }
        
        if textField == emailEdit {
            isModified = true
        }

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == editName {
            editName.resignFirstResponder()
        }
        
        return true
    }
}

//
// MARK: - RestApi
//
extension MyProfileVC: BaseRestApi {
    func updateProfile(name: String, birthDay:String, email: String, gender: Int, profileImage: String) {
        LoadingDialog.show()
        
        let dbDirthDay = birthDay.replaceAll(".", with: "-")
        Rest.makeProfile(name: name, birthday: dbDirthDay, gender: gender, email: email, profileImage:profileImage, success: { [weak self, gender] (result) -> Void in
            LoadingDialog.dismiss()
            
            let user = Rest.user!
            let pwd = user.pwd;
            
            Rest.user = (result as! ModelUser)
            Rest.user.pwd = pwd
            Local.setUser(Rest.user)
            
            self?.isModified = false
//            self?.showToast("profile_changed"._localized)
            self?.popVC()
        }) { [weak self](_, err) -> Void in
            LoadingDialog.dismiss()
            self?.view.showToast(err)
        }
    }
    
    func uploadProfileImage(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        LoadingDialog.show()
        
        Rest.uploadFiles(files: [imageData], success: { [weak self] (result) -> Void in
            LoadingDialog.dismiss()
            
            let retFileName = result as! ModelUploadFileList
            
            let fileName = retFileName.fileNames[0]
            let fileUrl = retFileName.fileUrls[0]
            self?.onUploadedAvatar(url: fileUrl, name: fileName)
        }) { [weak self](_, err) -> Void in
            LoadingDialog.dismiss()
            self?.view.showToast(err)
        }
    }
}
