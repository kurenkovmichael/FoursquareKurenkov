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

        registerCell(ProfileAvatarCell.self, for: tableView)
        registerCell(ProfileNameCell.self, for: tableView)
        registerCell(ProfileBioCell.self, for: tableView)
        registerCell(ProfileLogoutCell.self, for: tableView)

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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileData = data[indexPath.row]
        switch profileData {
        case .avatar(let identifier):
            let cell = dequeueCell(ProfileAvatarCell.self,
                                   from: tableView,
                                   for: indexPath)
            imageViewConfigurator.configure(imageView: cell, identifier: identifier)
            return cell

        case .name(let firstName, let lastName):
            let cell = dequeueCell(ProfileNameCell.self,
                                   from: tableView,
                                   for: indexPath)
            cell.configure(firstName: firstName, lastName: lastName)
            return cell

        case .contact(let type, let content):
            let cell = dequeueCell(ProfileBioCell.self,
                                   from: tableView,
                                   for: indexPath)
            cell.configure(bio: "\(type): \(content)")
            return cell

        case .bio(let bio):
            let cell = dequeueCell(ProfileBioCell.self,
                                   from: tableView,
                                   for: indexPath)
            cell.configure(bio: bio)
            return cell

        case .logout:
            return dequeueCell(ProfileLogoutCell.self,
                               from: tableView,
                               for: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let profileData = data[indexPath.row]
        switch profileData {
        case .logout:
            output.didTriggeredLogoutTappedEvent()
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        if let avatarCell = cell as? ProfileAvatarCell {
            avatarCell.cellWillDisplay()
        }
    }

    // MARK: - Pribate

    func registerCell<T>(_ type: T.Type, for tableView: UITableView)
        where T: UITableViewCell {
            let cellType = String(describing: T.self)
            tableView.register(UINib.init(nibName: cellType, bundle: nil),
                               forCellReuseIdentifier: cellType)
    }

    func dequeueCell<T>(_ type: T.Type, from tableView: UITableView,
                        for indexPath: IndexPath) -> T
        where T: UITableViewCell {
            return tableView.dequeueReusableCell(withIdentifier: String(describing: T.self),
                                                 for: indexPath) as? T ?? T()
    }
}
