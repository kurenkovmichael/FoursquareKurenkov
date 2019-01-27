import UIKit

extension UIView {
    func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 6)
    }
}

extension UIButton {
    func setupAsRoundButton(radius: Int) {
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        tintColorDidChange()
    }
}
