import UIKit
import BrightFutures
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

    @IBOutlet var loaderView: LoaderView! {
        didSet {
            loaderView.isHidden = true
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

        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: cellId)

        getPosts()
    }

    // MARK: - Functions

    private func getPosts() {
        loaderView.isHidden = false
        KDataProvider.feed()
            .onSuccess { [weak self] posts in
                self?.loaderView.isHidden = true
                self?.posts = posts
                self?.tableView.reloadData()
        }
        .onFailure { [weak self] error in
            self?.loaderView.isHidden = true
            self?.showAlert()
        }
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
        guard let postIndex = posts.firstIndex(where: { $0.id == id}) else {
            return
        }

        (posts[postIndex].currentUserLikesThisPost ? KDataProvider.unlikePost(with: id) : KDataProvider.likePost(with: id))
            .onSuccess { _ in }
            .onFailure { [weak self] error in
                self?.showAlert()
        }

        posts[postIndex].like(shouldKeepLiked: false)
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
        guard let postIndex = posts.firstIndex(where: { $0.id == id}) else {
            return
        }

        posts[postIndex].like(shouldKeepLiked: true)
        tableView.reloadData()

        KDataProvider.likePost(with: id)
        .onSuccess { _ in }
        .onFailure { [weak self] error in
            self?.showAlert()
        }
    }
}
