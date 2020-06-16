import Foundation
import FirstCourseFinalTaskChecker

class Post: PostProtocol {

    var id: PostProtocol.Identifier

    var author: GenericIdentifier<UserProtocol>

    var description: String

    var imageURL: URL

    var createdTime: Date

    var currentUserLikesThisPost: Bool

    var likedByCount: Int

    init(id: PostProtocol.Identifier,
         author: GenericIdentifier<UserProtocol>,
         description: String,
         imageURL: URL,
         createdTime: Date,
         currentUserLikesThisPost: Bool,
         likedByCount: Int) {

        self.id = id
        self.author = author
        self.description = description
        self.imageURL = imageURL
        self.createdTime = createdTime
        self.currentUserLikesThisPost = currentUserLikesThisPost
        self.likedByCount = likedByCount
    }

}


class PostsStorageClass: PostsStorageProtocol {
    var currentUserID: GenericIdentifier<UserProtocol>
    var posts: [Post]
    var likes: [(GenericIdentifier<UserProtocol>, GenericIdentifier<PostProtocol>)]
    var count: Int {
        return posts.count
    }

    required init(posts: [PostInitialData],
                  likes: [(GenericIdentifier<UserProtocol>, GenericIdentifier<PostProtocol>)],
                  currentUserID: GenericIdentifier<UserProtocol>) {
        self.posts =  posts.map { postData in
            let id = postData.id
            let author = postData.author
            let description = postData.description
            let imageURL = postData.imageURL
            let createdTime = postData.createdTime
            let currentUserLikesThisPost = likes.contains(where:{
                $0.0 == currentUserID && $0.1 == postData.id })
            let likedByCount = likes.filter{ $0.1 == postData.id }.count

            let post = Post(id: id,
                            author: author,
                            description: description,
                            imageURL: imageURL,
                            createdTime: createdTime,
                            currentUserLikesThisPost: currentUserLikesThisPost,
                            likedByCount: likedByCount)
            return post
        }

        self.likes = likes
        self.currentUserID = currentUserID
    }


    func post(with postID: GenericIdentifier<PostProtocol>) -> PostProtocol? {
        return posts.first(where: { post in
            post.id == postID})
    }

    func findPosts(by authorID: GenericIdentifier<UserProtocol>) -> [PostProtocol] {
        return posts.filter { post in
            post.author == authorID}
    }

    func findPosts(by searchString: String) -> [PostProtocol] {
        return posts.filter { post in
            post.description == searchString }
    }

    func likePost(with postID: GenericIdentifier<PostProtocol>) -> Bool {
        guard let post = posts.first(where: { $0.id == postID }) else {
            return false
        }

        if post.currentUserLikesThisPost {
            return true
        }

        post.likedByCount += 1
        post.currentUserLikesThisPost = true

        likes.append((currentUserID, postID))
        return true
    }

    func unlikePost(with postID: GenericIdentifier<PostProtocol>) -> Bool {
        guard let post = posts.first(where: { $0.id == postID }) else {
            return false
        }

        if !post.currentUserLikesThisPost {
            return true
        }

        post.likedByCount -= 1
        post.currentUserLikesThisPost = false

        likes.removeAll(where: { $0.0 == currentUserID && $0.1 == postID})
        return true
    }

    func usersLikedPost(with postID: GenericIdentifier<PostProtocol>) -> [GenericIdentifier<UserProtocol>]? {
        guard let _ = post(with: postID) else {
            return nil
        }

        return likes.filter { like in
            like.1 == postID
        }.map { like in
            like.0
        }
    }
}
