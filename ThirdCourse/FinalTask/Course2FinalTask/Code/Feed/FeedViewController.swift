import UIKit
import DataProvider

class FeedViewController: BaseViewController {
    private struct Constant {
        static let showAuthorProfileSegueID = "showAuthorProfile"
        static let showLikesListSegueID = "showLikesList"
    }

    //MARK: - IBOutlets

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    // MARK: - Private properties

    private var posts: [Post] = []
    private let cellId = String(describing: FeedCell.self)
    private let segueHandler = SegueHandler()

    private var postId: Post.Identifier!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        DataProviders.shared.postsDataProvider.feed(queue: DispatchQueue.global(qos: .userInitiated)) { [weak self] posts in
            guard let posts = posts else {
                DispatchQueue.main.async {
                    self?.showAlert()
                }
                return
            }

            self?.posts = posts
        }

        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate { }

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FeedCell
        cell.configure(with: posts[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - FeedCellDelagate

extension FeedViewController: FeedCellDelagate {
    func handleAuthorUsernameTap(id: User.Identifier) {
        segueHandler.perform(from: self, identifier: Constant.showAuthorProfileSegueID) { controller in
            if let controller = controller as? ProfileViewController {
                controller.userId = id
            }
        }
    }

    func handleAuthorAvatarTap(id: User.Identifier) {
        segueHandler.perform(from: self, identifier: Constant.showAuthorProfileSegueID) { controller in
            if let controller = controller as? ProfileViewController {
                controller.userId = id
            }
        }
    }

    func handleLikeButtonTap(id: Post.Identifier) {
        let _ = DataProviders.shared.postsDataProvider.post(with: id)!.currentUserLikesThisPost ? DataProviders.shared.postsDataProvider.unlikePost(with: id) : DataProviders.shared.postsDataProvider.likePost(with: id)
        posts = DataProviders.shared.postsDataProvider.feed()
        tableView.reloadData()
    }

    func handleLikesCountLabelTap(id: Post.Identifier) {
        segueHandler.perform(from: self, identifier: Constant.showLikesListSegueID) { controller in
            if let controller = controller as? ListViewController {
                controller.destiny = .likes
                controller.postId = id
            }
        }
    }

    func handlePostDoubleTap(id: Post.Identifier) {
        let _ = DataProviders.shared.postsDataProvider.likePost(with: id)
        posts = DataProviders.shared.postsDataProvider.feed()
        tableView.reloadData()
    }
}
