import BrightFutures
import DataProvider
import UIKit

enum AnyError: Error {
    case unknown
}

class KDataProvider {
    static private var loaderView: LoaderView = {
        guard let window = UIApplication.shared.keyWindow else { fatalError() }
        let view = LoaderView(frame: window.bounds)
        return view
    }()

    static func showLoaderView() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        DispatchQueue.main.async {
            window.addSubview(loaderView)
        }
    }

    static func hideLoaderView() {
        DispatchQueue.main.async {
            loaderView.removeFromSuperview()
        }
    }

    // MARK: - Users Data Provider

    static func currentUser() -> Future<User, AnyError> {
        let promise = Promise<User, AnyError>()

        DataProviders.shared.usersDataProvider.currentUser(queue: DispatchQueue.global(qos: .userInitiated)) { user in
            guard let user = user else {
                promise.failure(.unknown)
                return
            }

            promise.success(user)
        }

        return promise.future
    }

    static func user(with userID: DataProvider.User.Identifier) -> Future<User, AnyError> {
        let promise = Promise<User, AnyError>()

        DataProviders.shared.usersDataProvider.user(with: userID, queue: DispatchQueue.global(qos: .userInitiated)) { user in
            guard let user = user else {
                promise.failure(.unknown)
                return
            }

            promise.success(user)
        }

        return promise.future
    }

    static func follow(_ userIDToUnfollow: DataProvider.User.Identifier) -> Future<User, AnyError> {
        let promise = Promise<User, AnyError>()

        DataProviders.shared.usersDataProvider.follow(userIDToUnfollow, queue: DispatchQueue.global(qos: .userInitiated)) { user in
            guard let user = user else {
                promise.failure(.unknown)
                return
            }

            promise.success(user)
        }

        return promise.future
    }

    static func unfollow(_ userIDToUnfollow: DataProvider.User.Identifier) -> Future<User, AnyError> {
        let promise = Promise<User, AnyError>()

        DataProviders.shared.usersDataProvider.unfollow(userIDToUnfollow, queue: DispatchQueue.global(qos: .userInitiated)) { user in
            guard let user = user else {
                promise.failure(.unknown)
                return
            }

            promise.success(user)
        }

        return promise.future
    }

    static func usersFollowingUser(with userID: DataProvider.User.Identifier) -> Future<[User], AnyError> {
        let promise = Promise<[User], AnyError>()

        DataProviders.shared.usersDataProvider.usersFollowingUser(with: userID, queue: DispatchQueue.global(qos: .userInitiated)) { users in
            guard let users = users else {
                promise.failure(.unknown)
                return
            }

            promise.success(users)
        }

        return promise.future
    }

    static func usersFollowedByUser(with userID: DataProvider.User.Identifier) -> Future<[User], AnyError> {
        let promise = Promise<[User], AnyError>()

        DataProviders.shared.usersDataProvider.usersFollowedByUser(with: userID, queue: DispatchQueue.global(qos: .userInitiated)) { users in
            guard let users = users else {
                promise.failure(.unknown)
                return
            }

            promise.success(users)
        }

        return promise.future
    }

    // MARK: - Posts Data Provider

    static func feed() -> Future<[Post], AnyError> {
        let promise = Promise<[Post], AnyError>()

        DataProviders.shared.postsDataProvider.feed(queue: DispatchQueue.global(qos: .userInitiated)) { posts in
            guard let posts = posts else {
                promise.failure(.unknown)
                return
            }

            promise.success(posts)
        }

        return promise.future
    }

    static func post(with postID: DataProvider.Post.Identifier) -> Future<Post, AnyError> {
        let promise = Promise<Post, AnyError>()

        DataProviders.shared.postsDataProvider.post(with: postID, queue: DispatchQueue.global(qos: .userInitiated)) { post in
            guard let post = post else {
                promise.failure(.unknown)
                return
            }

            promise.success(post)
        }

        return promise.future
    }

    static func findPosts(by authorID: DataProvider.User.Identifier) -> Future<[Post], AnyError> {
        let promise = Promise<[Post], AnyError>()

        DataProviders.shared.postsDataProvider.findPosts(by: authorID, queue: DispatchQueue.global(qos: .userInitiated)) { posts in
            guard let posts = posts else {
                promise.failure(.unknown)
                return
            }

            promise.success(posts)
        }

        return promise.future
    }

    static func likePost(with postID: DataProvider.Post.Identifier) -> Future<Post, AnyError> {
        let promise = Promise<Post, AnyError>()

        DataProviders.shared.postsDataProvider.likePost(with: postID, queue: DispatchQueue.global(qos: .userInitiated)) { post in
            guard let post = post else {
                promise.failure(.unknown)
                return
            }

            promise.success(post)
        }

        return promise.future
    }

    static func unlikePost(with postID: DataProvider.Post.Identifier) -> Future<Post, AnyError> {
        let promise = Promise<Post, AnyError>()

        DataProviders.shared.postsDataProvider.unlikePost(with: postID, queue: DispatchQueue.global(qos: .userInitiated)) { post in
            guard let post = post else {
                promise.failure(.unknown)
                return
            }

            promise.success(post)
        }

        return promise.future
    }

    static func usersLikedPost(with postID: DataProvider.Post.Identifier) -> Future<[User], AnyError> {
        let promise = Promise<[User], AnyError>()

        DataProviders.shared.postsDataProvider.usersLikedPost(with: postID, queue: DispatchQueue.global(qos: .userInitiated)) { users in
            guard let users = users else {
                promise.failure(.unknown)
                return
            }

            promise.success(users)
        }

        return promise.future
    }

    static func newPost(with image: UIImage, description: String) -> Future<Post, AnyError> {
        let promise = Promise<Post, AnyError>()

        DataProviders.shared.postsDataProvider.newPost(with: image, description: description, queue: DispatchQueue.global(qos: .userInitiated)) { post in
            guard let post = post else {
                promise.failure(.unknown)
                return
            }

            promise.success(post)
        }

        return promise.future
    }

    // MARK: - Photo Data Provider

    static func photos() -> Future<[UIImage], AnyError> {
        return Future<[UIImage], AnyError>(value: DataProviders.shared.photoProvider.photos())
    }

    static func thumbnailPhotos() -> Future<[UIImage], AnyError> {
        return Future<[UIImage], AnyError>(value: DataProviders.shared.photoProvider.thumbnailPhotos())
    }
}
