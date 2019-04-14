import Foundation

protocol ViewContainerDelegate: class {
    func show(childView child: UIView, completion: (() -> Void)?)
    func hide(childView child: UIView, completion: (() -> Void)?)
}

class ViewContainer {

    private weak var delegate: ViewContainerDelegate?

    init(delegate: ViewContainerDelegate) {
       self.delegate = delegate
    }

    func show(view child: UIView) {
        viewContainerState.childView = child
        determinantViewContainerState()
    }

    func hideView() {
        viewContainerState.childView = nil
        determinantViewContainerState()
    }

    private struct ViewContainerState {
        var childView: UIView?
        var shownChildView: UIView?
        var  animationInProgress: Bool = false
    }

    private var viewContainerState = ViewContainerState()

    private func determinantViewContainerState() {
        guard let delegate = delegate else {
            viewContainerState.childView = nil
            viewContainerState.shownChildView = nil
            viewContainerState.animationInProgress = false
            return
        }

        guard !viewContainerState.animationInProgress else {
            return
        }

        if let child = viewContainerState.childView,
            viewContainerState.shownChildView == nil {

            viewContainerState.animationInProgress = true
            delegate.show(childView: child) {
                self.viewContainerState.shownChildView = child
                self.viewContainerState.animationInProgress = false
                self.determinantViewContainerState()
            }

        } else if let shownChildView = viewContainerState.shownChildView,
            shownChildView != viewContainerState.childView {

            viewContainerState.animationInProgress = true
            delegate.hide(childView: shownChildView) {
                self.viewContainerState.shownChildView = nil
                self.viewContainerState.animationInProgress = false
                self.determinantViewContainerState()
            }
        }
    }
}
