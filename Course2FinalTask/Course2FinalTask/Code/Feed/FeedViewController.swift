//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Nikolay Zhurba on 20.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FeedViewController: UIViewController {
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
    private var userId: DataProvider.User.Identifier!
    private var postId: DataProvider.Post.Identifier!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        posts = DataProviders.shared.postsDataProvider.feed()
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: cellId)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        hidesBottomBarWhenPushed = false
        switch segue.identifier {
        case Constant.showAuthorProfileSegueID:
            let vc = segue.destination as! ProfileViewController
            vc.userId = userId
        case Constant.showLikesListSegueID:
            let vc = segue.destination as! LikesViewController
            vc.postId = postId
        default:
            break
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
        userId = id
        performSegue(withIdentifier: Constant.showAuthorProfileSegueID, sender: self)
    }

    func handleAuthorAvatarTap(id: User.Identifier) {
        userId = id
        performSegue(withIdentifier: Constant.showAuthorProfileSegueID, sender: self)
    }

    func handleLikeButtonTap(id: Post.Identifier) {
        let _ = DataProviders.shared.postsDataProvider.post(with: id)!.currentUserLikesThisPost ? DataProviders.shared.postsDataProvider.unlikePost(with: id) : DataProviders.shared.postsDataProvider.likePost(with: id)
        posts = DataProviders.shared.postsDataProvider.feed()
        tableView.reloadData()
    }

    func handleLikesCountLabelTap(id: Post.Identifier) {
        postId = id
        performSegue(withIdentifier: Constant.showLikesListSegueID, sender: self)
    }

    func handlePostDoubleTap(id: Post.Identifier) {
        let _ = DataProviders.shared.postsDataProvider.likePost(with: id)
        posts = DataProviders.shared.postsDataProvider.feed()
        tableView.reloadData()
    }
}
