//
//  ContactusVC.swift
//  Traystorage
//

import Foundation
import UIKit
import SVProgressHUD

class ContactusVC: BaseVC {
    @IBOutlet var tfSubject: UITextField!
    @IBOutlet var tvDetail: UITextView!
    @IBOutlet var vwDetailHint: UILabel!
    
    private var isChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
    }
    
    override func removeFromParent() {
    }
    
    func initVC() {
    }
    
    override func hideKeyboard() {
        tfSubject.resignFirstResponder()
        tvDetail.resignFirstResponder()
    }
    
    override func onBackProcess(_ viewController: UIViewController) {
        if let popDelegate = self.popDelegate {
            popDelegate.onWillBack("contactus", isChanged ? "updated" : "none")
        }
        //super.onBackProcess(viewController)
        popVC()
    }
    
    
    @IBAction func onClickSend(_ sender: Any) {
        hideKeyboard()
        
        guard let subject = tfSubject.text?.trimmingCharacters(in: CharacterSet.whitespaces), !subject.isEmpty else {
            self.view.showToast("inquiry_title_input"._localized)
            return
        }
        
        guard let content = tvDetail.text?.trimmingCharacters(in: CharacterSet.whitespaces), !content.isEmpty else {
            self.view.showToast("inquiry_content_input"._localized)
            return
        }
        
        if content.count < 10 {
            self.view.showToast("inquiry_content10_input"._localized)
            return
        }
        
        ConfirmDialog.show(self, title: "send"._localized, message: "inquiry_save"._localized, showCancelBtn: true) { [weak self]() -> Void in
            self?.insertAsk(subject, content);
        }
    }
    
    public func onInsertAskSuccess() {
        self.view.showToast("inquiry_save_confirm"._localized)
        self.tfSubject.text = ""
        self.tvDetail.text = ""
        self.isChanged = true
//        self.onBackProcess(self)
        if let popDelegate = self.popDelegate {
            popDelegate.onWillBack("contactus", isChanged ? "updated" : "none")
        }
        //super.onBackProcess(viewController)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.popVC()
        }
        
    }
    
    private func insertAsk(_ subject:String,_ content:String) {
        LoadingDialog.show()
        Rest.insertAsk(title:subject, content:content, success:{ [weak self](result) in
            LoadingDialog.dismiss()
            self?.onInsertAskSuccess()
        }) { [weak self](code, err) in
            LoadingDialog.dismiss()
            self?.view.showToast(err)
        }
    }
}

extension ContactusVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
        let newLen = (textField.text?.count ?? 0) - range.length + string.count

        if textField == tfSubject, newLen > 30 {
            return false
        }

        return true
    }
}

extension ContactusVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        vwDetailHint.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text, text.isEmpty {
            vwDetailHint.isHidden = false
        }
    }
}
