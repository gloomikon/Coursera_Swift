import UIKit
import DataProvider

protocol ProfileTopViewDelegate: class {
    func openFollowers()
    func openFollowings()
}

class ProfileTopView: UIView {

    // MARK: - IBOutlets

    @IBOutlet var contentView: UIView!

    @IBOutlet var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        }
    }

    @IBOutlet var fullNameLabel: UILabel! {
        didSet {
            fullNameLabel.font = .systemFont(ofSize: 14)
        }
    }

    @IBOutlet var followedByCountLabel: UILabel! {
        didSet {
            followedByCountLabel.font = .systemFont(ofSize: 14, weight: .semibold)

            let recognizer = UITapGestureRecognizer(target: self, action: #selector(followedByCountLabelWasTapped))
            followedByCountLabel.addGestureRecognizer(recognizer)
        }
    }

    @IBOutlet var followsCountLabel: UILabel! {
        didSet {
            followsCountLabel.font = .systemFont(ofSize: 14, weight: .semibold)

            let recognizer = UITapGestureRecognizer(target: self, action: #selector(followsCountLabelWasTapped))
            followsCountLabel.addGestureRecognizer(recognizer)
        }
    }

    // MARK: - Properties

    weak var delegate: ProfileTopViewDelegate?

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        let nib = UINib(nibName: "ProfileTopView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }

    // MARK: - Configurations

    func configure(with user: User) {
        avatarImageView.image = user.avatar
        fullNameLabel.text = user.fullName
        followedByCountLabel.text = "Followers: \(user.followedByCount)"
        followsCountLabel.text = "Following: \(user.followsCount)"
    }

    // MARK: - Actions

    @objc private func followedByCountLabelWasTapped() {
        delegate?.openFollowers()
    }

    @objc private func followsCountLabelWasTapped() {
        delegate?.openFollowings()
    }
}
