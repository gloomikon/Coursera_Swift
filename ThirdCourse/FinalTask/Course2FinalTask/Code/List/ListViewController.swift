//
//  LikesViewController.swift
//  Course2FinalTask
//
//  Created by Nikolay Zhurba on 25.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

enum ListViewControllerDestiny {
    case likes
    case following
    case followers
}

class ListViewController: UIViewController {
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

    private var userToDisplayId: User.Identifier!
    private var usersToDisplay: [User]?
    private let cellIdentifier = String(describing: ListTableViewCell.self)

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        switch destiny {
        case .likes:
            title = Constant.likesTitle
            usersToDisplay = DataProviders.shared.postsDataProvider.usersLikedPost(with: postId)?
                .compactMap { id in
                    return DataProviders.shared.usersDataProvider.user(with: id)
            }
        case .following:
            title = Constant.followingTitle
            usersToDisplay = DataProviders.shared.usersDataProvider.usersFollowedByUser(with: userId)
        case .followers:
            title = Constant.followersTitle
            usersToDisplay = DataProviders.shared.usersDataProvider.usersFollowingUser(with: userId)
        case .none:
            break
        }

        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ProfileViewController else {
            return
        }

        vc.userId = userToDisplayId
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
        userToDisplayId = usersLikedPost[indexPath.row].id
        performSegue(withIdentifier: Constant.gotoProfileSegueId, sender: self)
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersToDisplay?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let usersToDisplay = usersToDisplay,
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListTableViewCell else {
                return UITableViewCell()
        }
        cell.configure(with: usersToDisplay[indexPath.row])
        return cell
    }
}
