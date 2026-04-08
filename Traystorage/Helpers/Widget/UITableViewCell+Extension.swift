import UIKit

extension UITableViewCell {
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
      
            return table as? UITableView
        }
    }
}
