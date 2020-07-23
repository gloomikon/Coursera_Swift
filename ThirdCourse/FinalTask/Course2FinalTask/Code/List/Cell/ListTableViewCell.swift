import UIKit
import DataProvider

class ListTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var usernameLabel: UILabel!

    // MARK: - Configure

    func configure(with user: User) {
        avatarImageView.image = user.avatar
        usernameLabel.text = user.fullName

        self.selectionStyle = .none
    }
}
