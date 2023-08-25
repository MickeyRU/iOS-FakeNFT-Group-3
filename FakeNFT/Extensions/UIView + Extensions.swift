import UIKit

extension UIView {
    func addViewWithNoTAMIC(_ views: UIView) {
        self.addSubview(views)
        views.translatesAutoresizingMaskIntoConstraints = false
    }
}

