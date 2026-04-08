import UIKit

class ToucheableCollectionView: UICollectionView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }

        return super.touchesShouldCancel(in: view)
    }
}
