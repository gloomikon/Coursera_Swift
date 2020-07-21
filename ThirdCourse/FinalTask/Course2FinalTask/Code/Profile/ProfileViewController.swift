//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Nikolay Zhurba on 20.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class ProfileViewController: UIViewController {
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

    var userId = DataProviders.shared.usersDataProvider.currentUser().id

    var posts: [Post]?
    private let cellId = String(describing: PostCell.self)

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        DataProviders.shared.usersDataProvider.currentUser(queue: DispatchQueue.global(qos: .userInitiated)) { [weak self] user in
            if let user = user {
                self?.userId = user.id
            }
        }

        guard let user = DataProviders.shared.usersDataProvider.user(with: userId) else {
            return
        }

        navigationItem.title = user.username

        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.itemSize = CGSize(width: view.bounds.size.width / 3, height: view.bounds.size.width / 3)

        posts = DataProviders.shared.postsDataProvider.findPosts(by: userId)
        topView.configure(with: user)
        collectionView.register(UINib(nibName: "PostCell", bundle: nil), forCellWithReuseIdentifier: cellId)
    }

    // MARK: - Functions

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ListViewController else {
            return
        }
        vc.userId = userId

        switch segue.identifier {
        case Constant.showFollowersSequeID:
            vc.destiny = .followers
        case Constant.showFollowingSequeID:
            vc.destiny = .following
        default:
            break
        }
    }
}

// MARK: - ProfileTopViewDelegate

extension ProfileViewController: ProfileTopViewDelegate {
    func openFollowers() {
        performSegue(withIdentifier: Constant.showFollowersSequeID, sender: self)
    }

    func openFollowings() {
        performSegue(withIdentifier: Constant.showFollowingSequeID, sender: self)
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
