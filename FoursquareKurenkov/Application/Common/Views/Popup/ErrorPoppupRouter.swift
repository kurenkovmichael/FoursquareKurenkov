import Foundation

class ErrorPoppupRouter {

    private let container: ViewContainer

    init(container: ViewContainer) {
        self.container = container
    }

    func showPoppup(withError error: Error?) {
        guard let view = PlaceholderView.fromDefaultNib() else {
            return
        }

        view.configure(title: NSLocalizedString("error.default.title", comment: ""),
                       subtitle: NSLocalizedString("error.default.message", comment: ""))
        container.show(view: view)
        scheduleHidePoppupTimer()
    }

    func hidePoppup() {
        resetHidePoppupTimer()
        container.hideView()
    }

    private var hidePoppupTimer: Timer?

    func scheduleHidePoppupTimer() {
        hidePoppupTimer?.invalidate()
        hidePoppupTimer = .scheduledTimer(withTimeInterval: 3, repeats: false) { (_) in
            self.hidePoppup()
            self.resetHidePoppupTimer()
        }
    }

    func resetHidePoppupTimer() {
        hidePoppupTimer?.invalidate()
        hidePoppupTimer = nil
    }
}
