import UIKit

extension UIView {

    func show(view child: UIView,
              on container: UIView,
              addSubview: ((UIView, UIView) -> Void)?,
              animations: (() -> Void)? = nil,
              completion: (() -> Void)? = nil) {
        UIView.performWithoutAnimation {
            addSubview?(container, child)
            container.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.25, animations: {
            animations?()
            container.superview?.layoutIfNeeded()
        }, completion: { (_) in
            completion?()
        })
    }

    func hide(view child: UIView,
              on container: UIView,
              animations: (() -> Void)? = nil,
              completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, animations: {
            animations?()
            container.superview?.layoutIfNeeded()
        }, completion: { (_) in
            child.removeFromSuperview()
            completion?()
        })
    }

}
