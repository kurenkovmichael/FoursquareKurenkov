import UIKit

class ProfileBioCell: UITableViewCell {

    @IBOutlet weak var bioLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        configure(bio: bio)
    }

    private var bio: String?

    func configure(bio: String?) {
        self.bio = bio
        bioLabel?.text = bio
    }

}
