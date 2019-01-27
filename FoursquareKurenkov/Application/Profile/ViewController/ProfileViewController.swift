import UIKit

class ProfileViewController: UITableViewController, ProfileViewInput {

    var imageViewConfigurator: ImageViewConfigurator!
    var output: ProfileViewOutput!
    var data: [ProfileViewData] = []

    // MARK: - ProfileViewInput

    func show(data: [ProfileViewData]) {
        self.data = data

        if isViewLoaded {
            tableView.reloadData()
        }
    }

    func showEmptyPlaceholder() {
        self.data.removeAll()

        if isViewLoaded {
            tableView.reloadData()
        }

        // TODO: Need implement
    }

    func showErrorPlaceholder(_ error: Error) {
        // TODO: Need implement
    }

    func showActivityIndicator() {
        tableView.refreshControl?.beginRefreshing()
    }

    func hideActivityIndicator() {
        tableView.refreshControl?.endRefreshing()
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerCell(ProfileAvatarCell.self)
        tableView.registerCell(ProfileNameCell.self)
        tableView.registerCell(ProfileBioCell.self)
        tableView.registerCell(ProfileLogoutCell.self)

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(handleRefresh(_:)),
                                            for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.didTriggeredWillAppearEvent()
    }

    // MARK: - Actions

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        output.didTriggeredPulldownEvent()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileData = data[indexPath.row]
        switch profileData {
        case .avatar(let identifier):
            let cell = tableView.dequeueCell(ProfileAvatarCell.self, for: indexPath)
            imageViewConfigurator.configure(imageView: cell, identifier: identifier)
            return cell

        case .name(let firstName, let lastName):
            let cell = tableView.dequeueCell(ProfileNameCell.self, for: indexPath)
            cell.configure(firstName: firstName, lastName: lastName)
            return cell

        case .contact(let type, let content):
            let cell = tableView.dequeueCell(ProfileBioCell.self, for: indexPath)
            cell.configure(bio: "\(type): \(content)")
            return cell

        case .bio(let bio):
            let cell = tableView.dequeueCell(ProfileBioCell.self, for: indexPath)
            cell.configure(bio: bio)
            return cell

        case .logout:
            return tableView.dequeueCell(ProfileLogoutCell.self, for: indexPath)
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let profileData = data[indexPath.row]
        switch profileData {
        case .logout:
            output.didTriggeredLogoutTappedEvent()
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if let avatarCell = cell as? ProfileAvatarCell {
            avatarCell.cellWillDisplay()
        }
    }

    }

    }

}
