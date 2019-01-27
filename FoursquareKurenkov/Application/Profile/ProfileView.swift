import Foundation

enum ContactType {
    case twitter, facebook, email, phone
}

enum ProfileViewData {
    case avatar(identifier: ImageIdentifier)
    case name(firstName: String, lastName: String?)
    case bio(bio: String)
    case contact(type: ContactType, content: String)
    case logout
}

protocol ProfileViewInput: class {
    func show(data: [ProfileViewData])
    func showActivityIndicator()
    func hideActivityIndicator()
}

protocol ProfileViewOutput: class {
    func didTriggeredWillAppearEvent()
    func didTriggeredPulldownEvent()
    func didTriggeredLogoutTappedEvent()
}
