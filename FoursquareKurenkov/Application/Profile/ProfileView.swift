import Foundation

enum ProfileViewData {
    case avatar(identifier: ImageIdentifier)
    case name(firstName: String, lastName: String?)
    case bio(bio: String)
    case contact(type: String, content: String)
    case logout
}

protocol ProfileViewInput: class {
    func show(data: [ProfileViewData])
    func showEmptyPlaceholder()
    func showErrorPlaceholder(_ error: Error)
    func showActivityIndicator()
    func hideActivityIndicator()
}

protocol ProfileViewOutput: class {
    func didTriggeredWillAppearEvent()
    func didTriggeredPulldownEvent()
    func didTriggeredLogoutTappedEvent()
}
