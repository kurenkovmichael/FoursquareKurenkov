import UIKit

extension UITableView {

    func registerCell<T>(_ type: T.Type)
        where T: UITableViewCell {
            let cellType = String(describing: T.self)
            register(UINib.init(nibName: cellType, bundle: nil), forCellReuseIdentifier: cellType)
    }

    func dequeueCell<T>(_ type: T.Type, for indexPath: IndexPath) -> T
        where T: UITableViewCell {
            return dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T ?? T()
    }

}
