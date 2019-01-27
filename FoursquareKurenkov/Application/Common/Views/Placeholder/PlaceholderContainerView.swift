import UIKit

class PlaceholderContainerView: UIView, ViewContainerDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func addOn(superview: UIView) {
        self.isUserInteractionEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self)

        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16).isActive = true
        superview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16).isActive = true
        superview.centerYAnchor.constraint(equalTo: bottomAnchor).isActive = true

        let heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
    }

    var placeholderView: UIView?

    func show() {
        if let placeholder = placeholderView {
            viewContainer?.show(view: placeholder)
        }
    }

    func hide() {
        viewContainer?.hideView()
    }

    // MARK: - Private

    private var viewContainer: ViewContainer?

    private func setup() {
        backgroundColor = .clear
        viewContainer = ViewContainer(delegate: self)
    }

    // MARK: - ViewContainerDelegate

    private var childBottomConstraint: NSLayoutConstraint?

    func show(childView child: UIView, completion: (() -> Void)?) {
        show(view: child, on: superview ?? self, addSubview: { _, child in
            child.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(child)
            self.topAnchor.constraint(equalTo: child.topAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: child.bottomAnchor).isActive = true
            self.leadingAnchor.constraint(equalTo: child.leadingAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: child.trailingAnchor).isActive = true
            self.alpha = 0
        }, animations: {
            self.alpha = 1
        }, completion: completion)
    }

    func hide(childView child: UIView, completion: (() -> Void)?) {
        hide(view: child, on: superview ?? self, animations: {
            self.alpha = 0
        }, completion: completion)
    }

}
