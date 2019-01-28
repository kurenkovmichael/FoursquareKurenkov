import UIKit

class FavoritesViewController: UIViewController,
                               UITableViewDataSource,
                               UITableViewDelegate,
                               FavoritesViewInput {

    var output: FavoritesViewOutput!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popupContainerView: UIView!

    let popupView = PopupContainerView()
    let placeholderView = PlaceholderContainerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNibForCell(FavoriteCell.self)

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(handleRefresh(_:)),
                                            for: .valueChanged)

        if let view = PlaceholderView.fromDefaultNib() {
            view.configure(title: NSLocalizedString("favorites.placeholder.title", comment: ""),
                           subtitle: NSLocalizedString("favorites.placeholder.message", comment: ""))
            placeholderView.placeholderView = view
        }
        placeholderView.addOn(superview: view)
        popupView.addOn(superview: popupContainerView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.didTriggeredWillAppearEvent()
    }

    // MARK: - Actions

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        output.didTriggeredPulldownEvent()
    }

    // MARK: - FavoritesViewInput

    private var dataProvider: DataProvider<Venue>?

    func showContentOf(dataProvider: DataProvider<Venue>) {
        self.dataProvider = dataProvider

        dataProvider.willChangeDataBlock = { [weak self] _ in
            self?.tableView.beginUpdates()
        }

        dataProvider.itemChangeBlock = { [weak self] _, venue, change in
            switch change {
            case .insert(let index):
                self?.tableView.insertRows(at: [IndexPath(item: index, section: 0)],
                                           with: .automatic)
            case .delete(let index):
                self?.tableView.deleteRows(at: [IndexPath(item: index, section: 0)],
                                           with: .automatic)
            case .move(let oldIndex, let newIndex):
                self?.tableView.moveRow(at: IndexPath(item: oldIndex, section: 0),
                                        to: IndexPath(item: newIndex, section: 0))
            case .update(let index):
                self?.tableView.rectForRow(at: IndexPath(item: index, section: 0))
            }
        }

        dataProvider.didChangeDataBlock = { [weak self] dataProvider in
            self?.tableView.endUpdates()
            self?.updatePlaceholder()
        }

        if isViewLoaded {
            tableView.reloadData()
            updatePlaceholder()
        }
    }

    func showRefrashActivityIndicator() {
        if let refreshControl = tableView.refreshControl,
            !refreshControl.isRefreshing {
            tableView.refreshControl?.beginRefreshing()
        }
    }

    func hideRefrashActivityIndicator() {
        tableView.refreshControl?.endRefreshing()
    }

    func showLoadMoreActivityIndicator() {
    }

    func hideLoadMoreActivityIndicator() {
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider?.numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(FavoriteCell.self, for: indexPath)
        if let venue = dataProvider?.item(at: indexPath.item) {
            cell.configure(with: venue)
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        // TODO: Need Imolement
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let handler = { [weak self] (action: UITableViewRowAction, index: IndexPath) in
            if let venue = self?.dataProvider?.item(at: index.item) {
                self?.output.didTriggeredUnfavoriteVenueEvent(venue)
            }
        }

        let unfavorite = UITableViewRowAction(style: .destructive,
                                              title: NSLocalizedString("favorites.unfavoriteActionName", comment: ""),
                                              handler: handler)
        return [unfavorite]
    }

    private let minOffsetToBottom: CGFloat = 50
    private var lastOffsetToBottom: CGFloat = 0

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.bounds.size.height
        let offset = scrollView.contentOffset.y

        let offsetToBottom = contentHeight - scrollViewHeight - offset
        if offsetToBottom < minOffsetToBottom && lastOffsetToBottom > minOffsetToBottom {
            self.output.didTriggeredScrolledToEndEvent()
        }

        lastOffsetToBottom = offsetToBottom
    }

    // MARK: - Private

    private func updatePlaceholder() {
        if dataProvider?.isEmpty ?? true {
            placeholderView.show()
        } else {
            placeholderView.hide()
        }
    }

}
