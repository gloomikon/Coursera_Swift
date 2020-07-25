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
    var posts: [Post]?

    private let segueHandler = SegueHandler()
    private let cellId = String(describing: PostCell.self)

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let userId = userId {
            setAppearance(with: userId)
        }
        else {
            KDataProvider.currentUser()
                .onSuccess { [weak self] user in
                    self?.userId = user.id
                    self?.setAppearance(with: user.id)
            }
            .onFailure { [weak self] error in
                self?.showAlert()
            }
        }

        collectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: cellId)
    }

    // MARK: - Functions

    private func setAppearance(with userId: User.Identifier) {
        KDataProvider.user(with: userId)
            .zip(KDataProvider.findPosts(by: userId))
            .onSuccess { [weak self] user, posts in
                guard let self = self else {
                    return
                }

                self.navigationItem.title = user.username
                self.flowLayout.minimumLineSpacing = .zero
                self.flowLayout.minimumInteritemSpacing = .zero
                self.flowLayout.itemSize = CGSize(width: self.view.bounds.size.width / 3, height: self.view.bounds.size.width / 3)
                self.topView.configure(with: user)

                self.posts = posts
                self.collectionView.reloadData()
        }
        .onFailure { [weak self] error in
            self?.showAlert()
        }
    }
}

// MARK: - ProfileTopViewDelegate

extension ProfileViewController: ProfileTopViewDelegate {
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
        return posts?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let posts = posts,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PostCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: posts[indexPath.row])
        return cell
    }
}
