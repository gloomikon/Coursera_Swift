import UIKit
import DataProvider

enum ListViewControllerDestiny {
    case likes
    case following
    case followers
}

class ListViewController: BaseViewController {
    private struct Constant {
        static let gotoProfileSegueId = "gotoProfile"
        static let likesTitle = "Likes"
        static let followersTitle = "Followers"
        static let followingTitle = "Following"
    }

    // MARK: - IBOutlets

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    // MARK: - Properties

    var postId: Post.Identifier!
    var userId: User.Identifier!
    var destiny: ListViewControllerDestiny!

    private var usersToDisplay: [User]?
    private let cellIdentifier = String(describing: ListTableViewCell.self)
    private let segueHandler = SegueHandler()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        getList()
    }

    // MARK: - Functions

    private func getList() {
        KDataProvider.showLoaderView()
        
        switch destiny {
        case .likes:
            title = Constant.likesTitle
            KDataProvider.usersLikedPost(with: postId)
                .onSuccess { [weak self] users in
                    KDataProvider.hideLoaderView()
                    self?.usersToDisplay = users
                    self?.tableView.reloadData()
            }
            .onFailure { [weak self] error in
                KDataProvider.hideLoaderView()
                self?.showAlert() { [weak self] _ in
                    self?.dismiss(animated: true)
                }
            }
        case .following:
            title = Constant.followingTitle
            KDataProvider.usersFollowedByUser(with: userId)
                .onSuccess { [weak self] users in
                    KDataProvider.hideLoaderView()
                    self?.usersToDisplay = users
                    self?.tableView.reloadData()
            }
            .onFailure { [weak self] error in
                KDataProvider.hideLoaderView()
                self?.showAlert() { [weak self] _ in
                    self?.dismiss(animated: true)
                }
            }
        case .followers:
            title = Constant.followersTitle
            KDataProvider.usersFollowingUser(with: userId)
                .onSuccess { [weak self] users in
                    KDataProvider.hideLoaderView()
                    self?.usersToDisplay = users
                    self?.tableView.reloadData()
            }
            .onFailure { [weak self] error in
                KDataProvider.hideLoaderView()
                self?.showAlert() { [weak self] _ in
                    self?.dismiss(animated: true)
                }
            }
        case .none:
            break
        }
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let usersLikedPost = usersToDisplay else {
            return
        }

        segueHandler.perform(from: self, identifier: Constant.gotoProfileSegueId) { viewController in
            if let viewController = viewController as? ProfileViewController {
                viewController.userId = usersLikedPost[indexPath.row].id
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersToDisplay?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let usersToDisplay = usersToDisplay,
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListTableViewCell else {
                return UITableViewCell()
        }

        cell.configure(with: usersToDisplay[indexPath.row])
        return cell
    }
}
