import UIKit

class PopupContainerView: UIView, ViewContainerDelegate {

    private var backgroundView: UIView!
    private var bottomConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func addOn(superview: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self)

        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16).isActive = true
        superview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16).isActive = true

        let heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true

        let topLowConstraint = superview.topAnchor.constraint(equalTo: topAnchor)
        topLowConstraint.priority = .defaultLow
        topLowConstraint.isActive = true

        let bottomLowConstraint = superview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -44)
        bottomLowConstraint.priority = .defaultHigh
        bottomLowConstraint.isActive = true

        bottomConstraint = superview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16)
    }

    // MARK: - Private

    private func setup() {
        backgroundColor = .clear
        setupShadow()

        backgroundView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = .white
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 12

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
    }

    // MARK: - ViewContainerDelegate

    private var childBottomConstraint: NSLayoutConstraint?

    func show(childView child: UIView, completion: (() -> Void)?) {
        show(view: child, on: superview ?? self, addSubview: { _, child in
            child.translatesAutoresizingMaskIntoConstraints = false
            self.backgroundView.addSubview(child)
            self.backgroundView.topAnchor.constraint(equalTo: child.topAnchor).isActive = true
            self.backgroundView.leadingAnchor.constraint(equalTo: child.leadingAnchor).isActive = true
            self.backgroundView.trailingAnchor.constraint(equalTo: child.trailingAnchor).isActive = true
            self.childBottomConstraint = self.backgroundView.bottomAnchor.constraint(equalTo: child.bottomAnchor)
        }, animations: {
            self.childBottomConstraint?.isActive = true
            self.bottomConstraint.isActive = true
        }, completion: completion)
    }

    func hide(childView child: UIView, completion: (() -> Void)?) {
        hide(view: child, on: superview ?? self, animations: {
            self.bottomConstraint.isActive = false
            self.childBottomConstraint?.isActive = false
        }, completion: completion)
    }

}
