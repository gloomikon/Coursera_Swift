import UIKit
import DataProvider

protocol ProfileTopViewDelegate: class {
    func openFollowers()
    func openFollowings()
    func handleFollowButtonTap()
}

struct ProfileTopViewViewState {
    let avatar: UIImage?
    let fullName: String
    let followedByCount: Int
    let followsCount: Int
    let currentUserFollowsThisUser: Bool
    let isUserCurrent: Bool
}

extension ProfileTopViewViewState {
    init(from user: User, isUserCurrent: Bool) {
        self.avatar = user.avatar
        self.fullName = user.fullName
        self.followedByCount = user.followedByCount
        self.followsCount = user.followsCount
        self.currentUserFollowsThisUser = user.currentUserFollowsThisUser
        self.isUserCurrent = isUserCurrent
    }
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

    @IBOutlet var followButton: UIButton! {
        didSet {
            followButton.isHidden = true
            followButton.backgroundColor = UIColor(red: 0 / 255, green: 150 / 255, blue: 255 / 255, alpha: 1)
            followButton.titleLabel?.font = .systemFont(ofSize: 15)
            followButton.setTitleColor(.white, for: .normal)
            followButton.contentEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
            followButton.layer.cornerRadius = 6
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

    func configure(with viewState: ProfileTopViewViewState) {
        avatarImageView.image = viewState.avatar
        fullNameLabel.text = viewState.fullName
        followedByCountLabel.text = "Followers: \(viewState.followedByCount)"
        followsCountLabel.text = "Following: \(viewState.followsCount)"

        followButton.setTitle(viewState.currentUserFollowsThisUser ? "Unfollow" : "Follow", for: .normal)
        followButton.isHidden = viewState.isUserCurrent
    }

    // MARK: - Actions

    @objc private func followedByCountLabelWasTapped() {
        delegate?.openFollowers()
    }

    @objc private func followsCountLabelWasTapped() {
        delegate?.openFollowings()
    }

    @IBAction func followButtonTapped(_ sender: Any) {
        delegate?.handleFollowButtonTap()
    }
}
