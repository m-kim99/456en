import UIKit

class DatepickerDialog: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var datepickerView: UIDatePicker!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var vwContents: UIView!
    
    private var _selected: Callback?
    private var _date: Date?
    
    public typealias Callback = (_ date: Date) -> ()
    
    static func show(_ vc: UIViewController, date: Date?, selected: Callback?) {
        let popup = DatepickerDialog("dialog_datepicker", date:date, selected: selected)
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        vc.present(popup, animated: true, completion: nil)
    }
    
    convenience init(_ nibName: String?, date: Date?, selected: Callback?) {
        self.init(nibName: nibName, bundle: nil)
        
        self._date = date
        self._selected = selected
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()

        lblTitle.text = "date_select"._localized
        datepickerView.maximumDate = Date()
        datepickerView.date = self._date ?? Date()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        vwContents.topCornerRadius = 30
    }
    
    private func close() {
        dismiss(animated: true) {
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    @IBAction func onClickBg(_ sender: Any) {
        self.close()
    }
    
    @IBAction func onClickConfirm(_ sender: Any) {
        dismiss(animated: true) {
            self.view.removeFromSuperview()
            self.removeFromParent()
            self._selected?(self.datepickerView!.date)
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.close()
    }
}
