//
//  MainVC.swift
//  Traystorage
//
//  Created by Dev on 2021. 11. 28..
//

import REFrostedViewController
import SVProgressHUD
import UIKit

class MainVC: BaseVC {
    @IBOutlet var tableViewDocument: UITableView!
    @IBOutlet var tfSearchText: UITextField!
    
    @IBOutlet var vwEmptyView: UIView!
    @IBOutlet var vwDocumentView: UIView!
    @IBOutlet var lblDocumentCount: UILabel!
    @IBOutlet var lblSearchEmpty: UILabel!
    
    @IBOutlet var lblCountTitle: UIFontLabel!
    @IBOutlet var vwHeaderMain: UIView!
    @IBOutlet var vwHeaderSearch: UIView!
    @IBOutlet var btnDocRegister: UIButton!
    
    var documents: [ModelDocument] = []
    var lastKeyword: String?
    
    private var currentSortType: Int = 0
    private let sortOptions = ["Latest", "Oldest", "Alphabetical"]
    private var sortButton: UIButton!
        
    private var vcMenu: MenuVC?


    private enum Tab: Int {
        case home = 0
        case map = 1
        case search = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        updateViewContent(isSearchResult: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(docReg), name: NSNotification.Name(rawValue: "doc_reg"), object: nil)
    }

    private func initVC() {
        vcMenu = MenuVC(nibName: "vc_menu", bundle: Bundle.main)
        vcMenu?.delegate = self
        showPopup()
        
        vwEmptyView.isHidden = false
        vwDocumentView.isHidden = false
        lblSearchEmpty.isHidden = true
        
        setupSortButton()
        setupMainHeader()
    }
    
    private func setupMainHeader() {
        let screenWidth = UIScreen.main.bounds.width
        let logoWidth = screenWidth * (200.0 / 375.0)
        let logoHeight = logoWidth * (40.0 / 160.0)
        if let logoView = view.viewWithTag(200) as? UIImageView {
            logoView.constraints.forEach { c in
                if c.firstAttribute == .width { c.constant = logoWidth }
                if c.firstAttribute == .height { c.constant = logoHeight }
            }
        }
        let hintColor = UIColor(red: 107/255.0, green: 108/255.0, blue: 110/255.0, alpha: 1)
        tfSearchText.attributedPlaceholder = NSAttributedString(
            string: "doc_search_hint"._localized,
            attributes: [.foregroundColor: hintColor]
        )
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let link = Local.getDimLink()
        if link != "" {
            DispatchQueue.global().async {
                Thread.sleep(forTimeInterval: 0.5)
                DispatchQueue.main.async {
                    self.goDetailPage()
                }
            }
            return
        }
    }
    
    @objc func docReg(_ notification: NSNotification) {
        loadDocument("", showLoading: true)
    }
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            onClickMenu("")
        }
    }

    private func updateViewContent(isSearchResult: Bool) {
        let searchText = tfSearchText.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if isSearchResult {
            if searchText.isEmpty {
                view.showToast("doc_empty_search"._localized)
                return
            }
        }
        vwHeaderMain.isHidden = isSearchResult
        vwHeaderSearch.isHidden = !isSearchResult
        btnDocRegister.isHidden = isSearchResult
        lblCountTitle.text = isSearchResult ? "search_result"._localized : "doc_count"._localized
        
        if isSearchResult {
            loadDocument(searchText, showLoading: true)
        } else {
            tfSearchText.text = nil
            loadDocument("", showLoading: true)
        }
    }

    private func showPopup() {
//        if Local.getNeverShowPopup() {
//            return
//        }
        
        LoadingDialog.show()
        Rest.popupInfo(success: { [weak self] result in
            LoadingDialog.dismiss()

            let popupList = result! as! ModelPopupList
            guard !popupList.contents.isEmpty else {
                return
            }
            
            let popup = popupList.contents[0]
            EveryDayDialog.show(self!, content: popup, notShowAction: nil, closeAction: nil) { [weak self] in
                self?.pushVC(NoticeDetailVC(nibName: "vc_notice_detail", bundle: nil), animated: true, params: ["code": popup.movePath])
            }
        }, failure: { [weak self] _, err in
            LoadingDialog.dismiss()
            self?.view.showToast(err)
        })
    }
    
    private func loadDocument(_ keyword: String, showLoading: Bool) {
//        tableViewDocument.beginUpdates()
        documents.removeAll()
        tableViewDocument.reloadData()
//        tableViewDocument.endUpdates()
        
        lastKeyword = keyword
        
        if showLoading {
            LoadingDialog.show()
        }
        Rest.documentList(keyword: keyword, success: { [weak self] result in
            if showLoading {
                LoadingDialog.dismiss()
            }
            
            let documentList = result! as! ModelDocumentList
            self?.documents.removeAll()
            self?.documents.append(contentsOf: documentList.contents)
            self?.documentChanged()
        }) { [weak self] code, msg in
            if showLoading {
                LoadingDialog.dismiss()
            }
            if code == 1 {
                self?.view.showToast("login_token_error".localized)
                self?.pushVC(LoginVC(nibName: "vc_login", bundle: nil), animated: true)
            } else {
                self?.view.showToast(msg)
            }
        }
    }
    
    private func documentChanged() {
        sortDocuments()
        lblDocumentCount.text = "\(documents.count) " + "doc_gon"._localized

        let isEmptyDocList = documents.isEmpty
        
        if let keyword = lastKeyword, keyword.isEmpty {
            vwEmptyView.isHidden = !isEmptyDocList
            vwDocumentView.isHidden = isEmptyDocList
            lblSearchEmpty.isHidden = true
        } else {
            vwEmptyView.isHidden = true
            vwDocumentView.isHidden = false
            lblSearchEmpty.text = "'" + (lastKeyword ?? "") + "'" + "search_empty_title"._localized
            lblSearchEmpty.isHidden = !isEmptyDocList
        }
    }
    
    //

    // MARK: - Action

    //
    @IBAction func onSearchDone(_ sender: Any) {
        hideKeyboard()
        updateViewContent(isSearchResult: true)
    }
    
    @IBAction func onSearchResultBack(_ sender: Any) {
        updateViewContent(isSearchResult: false)
    }
    
    override internal func hideKeyboard() {
        super.hideKeyboard()
        tfSearchText.resignFirstResponder()
    }
    
    @IBAction func onClickTabHome(_ sender: Any) {
//        changeTab(Tab.home)
    }
    
    @IBAction func onClickMenu(_ sender: Any) {
        vcMenu?.slideOpen(view)
    }
    
    // MARK: - Sort
    
    private func setupSortButton() {
        sortButton = UIButton(type: .system)
        sortButton.setTitle(sortOptions[0] + " ▾", for: .normal)
        sortButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        sortButton.setTitleColor(UIColor(red: 30.0/255.0, green: 49.0/255.0, blue: 157.0/255.0, alpha: 1), for: .normal)
        sortButton.contentHorizontalAlignment = .trailing
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        
        if let stackView = lblDocumentCount.superview as? UIStackView {
            stackView.addArrangedSubview(sortButton)
            sortButton.setContentHuggingPriority(.required, for: .horizontal)
            sortButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        if #available(iOS 14.0, *) {
            sortButton.showsMenuAsPrimaryAction = true
            updateSortMenu()
        } else {
            sortButton.addTarget(self, action: #selector(onClickSort), for: .touchUpInside)
        }
        
    }
    
    @available(iOS 14.0, *)
    private func updateSortMenu() {
        let actions = sortOptions.enumerated().map { (index, option) in
            UIAction(title: option, state: index == self.currentSortType ? .on : .off) { [weak self] _ in
                guard let self = self else { return }
                self.currentSortType = index
                self.sortButton.setTitle(option + " ▾", for: .normal)
                self.sortDocuments()
                self.updateSortMenu()
            }
        }
        sortButton.menu = UIMenu(title: "", children: actions)
    }
    
    @objc private func onClickSort() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for (index, option) in sortOptions.enumerated() {
            let action = UIAlertAction(title: option, style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.currentSortType = index
                self.sortButton.setTitle(option + " ▾", for: .normal)
                self.sortDocuments()
            }
            if index == currentSortType {
                action.setValue(true, forKey: "checked")
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func sortDocuments() {
        switch currentSortType {
        case 0:
            documents.sort { $0.create_time > $1.create_time }
        case 1:
            documents.sort { $0.create_time < $1.create_time }
        case 2:
            documents.sort { $0.title.localizedCompare($1.title) == .orderedAscending }
        default:
            break
        }
        tableViewDocument.reloadData()
    }
    
    @IBAction func onClickAdd(_ sender: Any) {
        let vc = DocumentRegisterVC(nibName: "vc_document_register", bundle: nil)
        vc.isNewDocument = true
        vc.popDelegate = self
        pushVC(vc, animated: true)
    }
    
    @IBAction func onClickSearch(_ sender: Any) {
        hideKeyboard()

        updateViewContent(isSearchResult: true)
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = cell.viewWithTag(1) as! UILabel
        let content = cell.viewWithTag(2) as! UILabel
        let tags = cell.viewWithTag(3) as! UILabel
        let imageView = cell.viewWithTag(4) as! UIImageView
        let labelView = cell.viewWithTag(5)!
        let date = cell.viewWithTag(6) as! UILabel
        
        let doc = documents[indexPath.row]
        title.text = doc.title
        content.text = doc.content
        if doc.tags.isEmpty {
            tags.text = ""
        } else {
            tags.text = "#" + doc.tags.joined(separator: " #")
        }
        date.text = doc.reg_time
        
        if doc.images.count > 0 {
            doc.setToImageView(at: 0, imageView: imageView)
        } else {
            imageView.image = nil
        }
        labelView.backgroundColor = AppColor.labelColors[doc.label]
        labelView.borderColor = .black
        if doc.label == 0 {
            labelView.borderWidth = 1.0
        } else {
            labelView.borderWidth = 0
        }
        
        return cell
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DocumentDetailVC(nibName: "vc_document_detail", bundle: nil)
        detailVC.documentId = documents[indexPath.row].doc_id
        detailVC.popDelegate = self
        pushVC(detailVC, animated: true)
    }
}

//

// MARK: - MenuDelegate

//

extension MainVC: MenuDelegate {
    func openProfile() {
        pushVC(MyProfileVC(nibName: "vc_my_profile", bundle: nil), animated: true)
    }
    
    func openInvite() {
        pushVC(InviteVC(nibName: "vc_invite", bundle: nil), animated: true)
    }
    
    func openContactus() {
//        self.pushVC(ContactusVC(nibName: "vc_contactus", bundle: nil), animated: true)
        pushVC(InquiryVC(nibName: "vc_inquiry", bundle: nil), animated: true)
    }
    
    func openNotice() {
        pushVC(NoticeVC(nibName: "vc_notice", bundle: nil), animated: true)
    }
    
    func openSetting() {
        pushVC(SettingVC(nibName: "vc_setting", bundle: nil), animated: true)
    }
}

extension MainVC: PopViewControllerDelegate {
    func onWillBack(_ sender: String, _ result: Any?) {
        if sender == "insert" {
            loadDocument(lastKeyword ?? "", showLoading: false)
        } else if sender == "update" {
            loadDocument(lastKeyword ?? "", showLoading: false)
        } else if sender == "delete" {
            let documentID = result as! Int
            
            for i in 0 ..< documents.count {
                if documents[i].doc_id == documentID {
                    documents.remove(at: i)
                    documentChanged()
                    break
                }
            }
            
            view.showToast("doc_deleted_toast"._localized)
        }
    }
}
