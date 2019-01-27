import UIKit

class FavoritesViewController: UIViewController,
                               UITableViewDataSource,
                               UITableViewDelegate,
                               FavoritesViewInput {

    var output: FavoritesViewOutput!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerCell(FavoriteCell.self)

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
//        output.didTriggeredScrolledToEndEvent()
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

        dataProvider.didChangeDataBlock = { [weak self] _ in
            self?.tableView.endUpdates()
        }

        if isViewLoaded {
            self.tableView.reloadData()
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
        //
    }

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
       //
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
}
