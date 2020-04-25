//
//  FeedCell.swift
//  Course2FinalTask
//
//  Created by Nikolay Zhurba on 20.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

protocol FeedCellDelagate: class {
    func handleAuthorUsernameTap(id: DataProvider.User.Identifier)
    func handleAuthorAvatarTap(id: DataProvider.User.Identifier)
    func handleLikeButtonTap(id: DataProvider.Post.Identifier)
    func handleLikesCountLabelTap(id: DataProvider.Post.Identifier)
    func handlePostDoubleTap(id: DataProvider.Post.Identifier)
}

class FeedCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private var authorAvatar: UIImageView! {
        didSet {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(authorAvatarTapped))
            authorAvatar.addGestureRecognizer(gestureRecognizer)
        }
    }

    @IBOutlet private var authorUsernameLabel: UILabel! {
        didSet {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(authorUsernameTapped))
            authorUsernameLabel.addGestureRecognizer(gestureRecognizer)
        }
    }

    @IBOutlet private var createdTimeLabel: UILabel!

    @IBOutlet var bigLikeImageView: UIImageView! {
        didSet {
            bigLikeImageView.alpha = 0
        }
    }

    @IBOutlet private var postImage: UIImageView! {
        didSet {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(postDoubleTapped))
            gestureRecognizer.numberOfTapsRequired = 2
            postImage.addGestureRecognizer(gestureRecognizer)
        }
    }

    @IBOutlet private var likeButton: UIButton!

    @IBOutlet private var likedByCountLabel: UILabel! {
        didSet {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesCountLabelTapped))
            likedByCountLabel.addGestureRecognizer(gestureRecognizer)
        }
    }

    @IBOutlet private var postDescriptionLabel: UILabel!

    // MARK: - Properties

    weak var delegate: FeedCellDelagate?
    private var authorId: DataProvider.User.Identifier?
    private var postId: DataProvider.Post.Identifier?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with post: Post) {
        authorAvatar.image = post.authorAvatar
        authorUsernameLabel.text = post.authorUsername
        createdTimeLabel.text = DateFormatter.postDateString(from: post.createdTime)
        postImage.image = post.image
        likeButton.tintColor = post.currentUserLikesThisPost ? .systemBlue : .lightGray
        likedByCountLabel.text = "Likes: \(post.likedByCount)"
        postDescriptionLabel.text = post.description

        authorId = post.author
        postId = post.id
    }

    // MARK: - Actions

    @IBAction private func likeButtonTapped(_ sender: Any) {
        guard let id = postId else {
            return
        }

        delegate?.handleLikeButtonTap(id: id)
    }

    @objc private func authorAvatarTapped() {
        guard let id = authorId else {
            return
        }

        delegate?.handleAuthorAvatarTap(id: id)
    }

    @objc private func authorUsernameTapped() {
        guard let id = authorId else {
            return
        }

        delegate?.handleAuthorUsernameTap(id: id)
    }

    @objc private func postDoubleTapped() {
        guard let id = postId else {
            return
        }

        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: [.curveLinear],
                       animations: { self.bigLikeImageView.alpha = 1.0 },
                       completion: { _ in
                        UIView.animate(withDuration: 0.3,
                                       delay: 0.2,
                                       options: [.curveEaseOut],
                                       animations: { self.bigLikeImageView.alpha = 0.0 },
                                       completion: nil)
        })

        delegate?.handlePostDoubleTap(id: id)
    }

    @objc private func likesCountLabelTapped() {
        guard let id = postId else {
            return
        }

        delegate?.handleLikesCountLabelTap(id: id)
    }
}

fileprivate extension DateFormatter {
    static func postDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium

        return formatter.string(from: date)
    }
}
