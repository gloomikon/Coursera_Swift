import UIKit
import DataProvider

class ProfileViewController: BaseViewController {
    private struct Constant {
        static let showFollowersSequeID = "showFollowers"
        static let showFollowingSequeID = "showFollowing"
    }

    // MARK: - IBOutlets

    @IBOutlet var topView: ProfileTopView! {
        didSet {
            topView.delegate = self
        }
    }

    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }

    @IBOutlet var flowLayout: UICollectionViewFlowLayout!

    // MARK: = Properties

    var userId: User.Identifier?
    var user: User!
    var posts: [Post] = []

    private let segueHandler = SegueHandler()
    private let cellId = String(describing: PostCell.self)

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        KDataProvider.showLoaderView()
        if let userId = userId {
            setAppearance(with: userId, vcWasPushed: true)
        }
        else {
            KDataProvider.currentUser()
                .onSuccess { [weak self] user in
                    self?.userId = user.id
                    self?.setAppearance(with: user.id, vcWasPushed: false)
            }
            .onFailure { [weak self] error in
                KDataProvider.hideLoaderView()
                self?.showAlert()
            }
        }

        collectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: cellId)
    }

    // MARK: - Functions

    func updatePosts() {
        guard let  userId = userId else {
            return
        }
        KDataProvider.findPosts(by: userId)
            .onSuccess { [weak self] posts in
                self?.posts = posts
                self?.collectionView.reloadData()
        }
    }

    func updateUserInfo() {
        KDataProvider.currentUser()
            .onSuccess { [weak self] user in
                self?.userId = user.id
                self?.topView.configure(with: .init(from: user,
                                                   isUserCurrent: true)
                )
        }
        .onFailure { error in }
    }

    private func setAppearance(with userId: User.Identifier, vcWasPushed: Bool) {
        KDataProvider.user(with: userId)
            .zip(KDataProvider.findPosts(by: userId))
            .onSuccess { [weak self] user, posts in
                guard let self = self else {
                    return
                }

                KDataProvider.hideLoaderView()
                self.user = user
                self.navigationItem.title = user.username
                self.flowLayout.minimumLineSpacing = .zero
                self.flowLayout.minimumInteritemSpacing = .zero
                self.flowLayout.itemSize = CGSize(width: self.view.bounds.size.width / 3, height: self.view.bounds.size.width / 3)
                self.topView.configure(with: .init(from: user,
                                                   isUserCurrent: UserSession.shared.currentUser.map { $0.id == userId } ?? false)
                )

                self.posts = posts
                self.collectionView.reloadData()
        }
        .onFailure { [weak self] error in
            KDataProvider.hideLoaderView()
            self?.showAlert() { [weak self] _ in
                if vcWasPushed {
                    self?.dismiss(animated: true)
                }
            }
        }
    }
}

// MARK: - ProfileTopViewDelegate

extension ProfileViewController: ProfileTopViewDelegate {
    func handleFollowButtonTap() {
        guard let userId = userId else {
            return
        }

        (user.currentUserFollowsThisUser ? KDataProvider.unfollow(userId) : KDataProvider.follow(userId))
            .onSuccess { [weak self] user in
                self?.user = user
                if let viewController = self?.tabBarController?.viewControllers?[2].children.first as? ProfileViewController {
                    viewController.updateUserInfo()
                }
        }
        .onFailure { [weak self] error in
            self?.showAlert()
        }

        topView.configure(with: .init(avatar: user.avatar,
                                      fullName: user.fullName,
                                      followedByCount: user.currentUserFollowsThisUser ? user.followedByCount - 1 : user.followedByCount + 1,
                                      followsCount: user.followsCount,
                                      currentUserFollowsThisUser: !user.currentUserFollowsThisUser,
                                      isUserCurrent: false)
        )
    }

    func openFollowers() {
        guard let userId = userId else {
            return
        }

        segueHandler.perform(from: self, identifier: Constant.showFollowersSequeID) { viewController in
            if let viewController = viewController as? ListViewController {
                viewController.userId = userId
                viewController.destiny = .followers
            }
        }
    }

    func openFollowings() {
        guard let userId = userId else {
            return
        }

        segueHandler.perform(from: self, identifier: Constant.showFollowingSequeID) { viewController in
            if let viewController = viewController as? ListViewController {
                viewController.userId = userId
                viewController.destiny = .following
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileViewController: UICollectionViewDelegate { }

// MARK: - UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PostCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: posts[indexPath.row])
        return cell
    }
}
