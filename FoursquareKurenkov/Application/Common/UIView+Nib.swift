import UIKit

extension UIView {

    class func fromDefaultNib() -> Self? {
        return fromDefaultNibHelper()
    }

    private class func fromDefaultNibHelper<T>() -> T? where T: UIView {
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        let views = nib.instantiate(withOwner: nil, options: nil)
        for view in views {
            if let view = view as? T {
                return view
            }
        }
        return nil
    }

}
