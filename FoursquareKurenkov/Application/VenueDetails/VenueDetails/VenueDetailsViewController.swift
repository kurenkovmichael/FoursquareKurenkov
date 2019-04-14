import UIKit

class VenueDetailsViewController: UIViewController,
                                  UITableViewDataSource,
                                  UITableViewDelegate,
                                  VenueDetailsViewInput {

    var output: VenueDetailsViewOutput!
    var imageViewConfigurator: ImageViewConfigurator!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popupContainerView: UIView!

    let popupView = PopupContainerView()
    let placeholderView = PlaceholderContainerView()

    private var favoriteButton: UIBarButtonItem?
    private var unfavoriteButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNibForCell(VenueDetailsPhotoCell.self)
        tableView.registerNibForCell(VenueDetailsNameCell.self)
        tableView.registerNibForCell(VenueDetailsDescriptionCell.self)
        tableView.registerNibForCell(VenueDetailsRatingCell.self)
        tableView.registerNibForCell(VenueDetailsLocationCell.self)
        tableView.registerNibForCell(VenueDetailsCategoriesCell.self)
        tableView.registerNibForCell(VenueDetailsPhoneCell.self)
        tableView.registerNibForCell(VenueDetailsSocialsCell.self)

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(handleRefresh(_:)),
                                            for: .valueChanged)

        favoriteButton = UIBarButtonItem(image: UIImage(named: "favorite"), style: .plain,
                                         target: self, action: #selector(favoriteButtonTapped(_:)))
        unfavoriteButton = UIBarButtonItem(image: UIImage(named: "favorite-full"), style: .plain,
                                           target: self, action: #selector(unfavoriteButtonTapped(_:)))
        updateFavoriteControll()

        if let view = PlaceholderView.fromDefaultNib() {
            view.configure(title: NSLocalizedString("venueDetails.placeholder.title", comment: ""),
                           subtitle: NSLocalizedString("venueDetails.placeholder.message", comment: ""))
            placeholderView.placeholderView = view
        }
        placeholderView.addOn(superview: view)
        popupView.addOn(superview: popupContainerView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.didTriggeredWillAppearEvent()
        placeholderView.show()
    }

    // MARK: - Actions

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        output.didTriggeredPulldownEvent()
    }

    @objc func favoriteButtonTapped(_ sender: Any) {
        output.didTriggeredFavoriteVenueEvent()
    }

    @objc func unfavoriteButtonTapped(_ sender: Any) {
        output.didTriggeredUnfavoriteVenueEvent()
    }

    // MARK: - VenueDetailsViewInput

    private var data: [VenueDetailsViewData] = []
    private var likes: Bool = false

    func show(data: [VenueDetailsViewData], likes: Bool) {
        self.data = data
        self.likes = likes

        if data.isEmpty {
            placeholderView.show()
        } else {
            placeholderView.hide()
        }

        if isViewLoaded {
            tableView.reloadData()
            updateFavoriteControll()
        }
    }

    func showRefrashActivityIndicator() {
        tableView.refreshControl?.beginRefreshing()
    }

    func hideRefrashActivityIndicator() {
        tableView.refreshControl?.endRefreshing()
    }

    func showFavoriteActivityIndicator() {
        favoriteButton?.isEnabled = false
        unfavoriteButton?.isEnabled = false
    }

    func hideFavoriteActivityIndicator() {
        favoriteButton?.isEnabled = true
        unfavoriteButton?.isEnabled = true
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let venueData = data[indexPath.row]

        switch venueData {
        case .photo(let identifier):
            let cell = tableView.dequeueCell(VenueDetailsPhotoCell.self, for: indexPath)
            imageViewConfigurator.configure(imageView: cell, identifier: identifier)
            return cell

        case .name(let name):
            let cell = tableView.dequeueCell(VenueDetailsNameCell.self, for: indexPath)
            cell.configure(name: name)
            return cell

        case .description(let description):
            let cell = tableView.dequeueCell(VenueDetailsDescriptionCell.self, for: indexPath)
            cell.configure(description: description)
            return cell

        case .rating(let rating, let color):
            let cell = tableView.dequeueCell(VenueDetailsRatingCell.self, for: indexPath)
            cell.configure(rating: rating, color: color)
            return cell

        case .location(let location):
            let cell = tableView.dequeueCell(VenueDetailsLocationCell.self, for: indexPath)
            cell.configure(location: location)
            return cell

        case .categories(let categories):
            let cell = tableView.dequeueCell(VenueDetailsCategoriesCell.self, for: indexPath)
            cell.configure(categories: categories)
            return cell

        case .phone(let phone):
            let cell = tableView.dequeueCell(VenueDetailsPhoneCell.self, for: indexPath)
            cell.configure(phone: phone)
            return cell

        case .social(let socials, let content):
            let cell = tableView.dequeueCell(VenueDetailsSocialsCell.self, for: indexPath)
            cell.configure(type: socials, content: content)
            return cell
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if let photoCell = cell as? VenueDetailsPhotoCell {
            photoCell.cellWillDisplay()
        }
    }

    // MARK: - Private

    func updateFavoriteControll() {
        if likes {
            navigationItem.rightBarButtonItem = unfavoriteButton
        } else {
            navigationItem.rightBarButtonItem = favoriteButton
        }
    }
}
