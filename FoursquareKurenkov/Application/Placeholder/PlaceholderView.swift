import UIKit

class PlaceholderView: UIView {

    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var titleContainer: UIView?

    @IBOutlet var subtitleLabel: UILabel?
    @IBOutlet var subtitleContainer: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        updateTitle()
        updateSubtitle()
    }

    public var titleText: String?
    public var subtitleText: String?

    func configure(title: String, subtitle: String) {
        titleText = title
        subtitleText = subtitle
        updateTitle()
        updateSubtitle()
    }

    func configure(title: String) {
        titleText = title
        subtitleText = nil
        updateTitle()
    }

    func configure(subtitle: String) {
        titleText = nil
        subtitleText = subtitle
        updateSubtitle()
    }

    private func updateTitle() {
        titleLabel?.text = titleText
        titleContainer?.isHidden = titleText?.isEmpty ?? true
    }

    private func updateSubtitle() {
        subtitleLabel?.text = subtitleText
        subtitleContainer?.isHidden = subtitleText?.isEmpty ?? true
    }

}
