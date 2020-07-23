import DataProvider

extension Post {
    mutating func like(shouldKeepLiked: Bool) {
        if shouldKeepLiked {
            if !currentUserLikesThisPost {
                currentUserLikesThisPost = true
                likedByCount += 1
            }
        }
        else {
            likedByCount += currentUserLikesThisPost ? -1 : 1
            currentUserLikesThisPost = !currentUserLikesThisPost
        }
    }
}
