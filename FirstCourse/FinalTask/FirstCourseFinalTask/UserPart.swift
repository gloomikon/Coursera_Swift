import Foundation
import FirstCourseFinalTaskChecker

class User: UserProtocol {
    var id: UserProtocol.Identifier

    var username: String

    var fullName: String

    var avatarURL: URL?

    var currentUserFollowsThisUser: Bool

    var currentUserIsFollowedByThisUser: Bool

    var followsCount: Int

    var followedByCount: Int

    init(id: UserProtocol.Identifier,
         username: String,
         fullName: String,
         avatarURL: URL?,
         currentUserFollowsThisUser: Bool,
         currentUserIsFollowedByThisUser: Bool,
         followsCount: Int,
         followedByCount: Int) {
        self.id = id
        self.username = username
        self.fullName = fullName
        self.avatarURL = avatarURL
        self.currentUserFollowsThisUser = currentUserFollowsThisUser
        self.currentUserIsFollowedByThisUser = currentUserIsFollowedByThisUser
        self.followsCount = followsCount
        self.followedByCount = followedByCount
    }
}


class UserStorageClass: UsersStorageProtocol {
    var users: [User]
    var currentUserID: GenericIdentifier<UserProtocol>
    var followers: [(GenericIdentifier<UserProtocol>, GenericIdentifier<UserProtocol>)]

    required init?(users: [UserInitialData],
                   followers: [(GenericIdentifier<UserProtocol>, GenericIdentifier<UserProtocol>)],
                   currentUserID: GenericIdentifier<UserProtocol>) {
        guard users.contains(where: {$0.id == currentUserID}) else {
            return nil
        }

        self.users = users.map { userInfo in
            let id = userInfo.id
            let username = userInfo.username
            let fullName = userInfo.fullName
            let avatarURL = userInfo.avatarURL
            let currentUserFollowsThisUser = userInfo.id == currentUserID ? false : followers.contains(where: { followLink in
            followLink.0 == currentUserID && followLink.1 == userInfo.id })
            let currentUserIsFollowedByThisUser = userInfo.id == currentUserID ? false : followers.contains(where:{ followLink in
            followLink.0 == userInfo.id && followLink.1 == currentUserID })
            let followsCount = followers.filter({ followLink in
                followLink.0 == userInfo.id }).count
            let followedByCount = followers.filter( { followLink in
                followLink.1 == userInfo.id }).count

            let user = User(id: id,
                            username: username,
                            fullName: fullName,
                            avatarURL: avatarURL,
                            currentUserFollowsThisUser: currentUserFollowsThisUser,
                            currentUserIsFollowedByThisUser: currentUserIsFollowedByThisUser,
                            followsCount: followsCount,
                            followedByCount: followedByCount)
            return user
        }

        self.followers = followers
        self.currentUserID = currentUserID
    }

    var count: Int {
        return users.count
    }

    func currentUser() -> UserProtocol {
        return user(with: currentUserID)!
    }

    func user(with userID: GenericIdentifier<UserProtocol>) -> UserProtocol? {
        return users.first(where: { user in
            user.id == userID})
    }

    func findUsers(by searchString: String) -> [UserProtocol] {
        return users.filter { user in
            return user.fullName == searchString || user.username == searchString
        }
    }

    func follow(_ userIDToFollow: GenericIdentifier<UserProtocol>) -> Bool {
        guard let user = users.first(where: {$0.id == userIDToFollow}),
            let userToFollow = users.first(where: {$0.id == currentUserID}) else {
                return false
        }

        if followers.contains(where: { followLink in
            followLink.0 == currentUserID && followLink.1 == userIDToFollow
        }) {
            return true
        }

        user.followedByCount += 1
        userToFollow.followsCount += 1

        followers.append((currentUserID, userIDToFollow))
        return true
    }

    func unfollow(_ userIDToUnfollow: GenericIdentifier<UserProtocol>) -> Bool {
        guard let user = users.first(where: {$0.id == userIDToUnfollow}),
            let userToUnfollow = users.first(where: {$0.id == currentUserID}) else {
                return false
        }

        user.followedByCount -= 1
        userToUnfollow.followsCount -= 1

        followers.removeAll(where: { followLink in
            followLink.0 == currentUserID && followLink.1 == userIDToUnfollow})
        return true
    }

    func usersFollowingUser(with userID: GenericIdentifier<UserProtocol>) -> [UserProtocol]? {
        guard let _ = user(with: userID) else {
            return nil
        }

        return followers.filter { followLink in
            return followLink.1 == userID
        }
        .compactMap { followLink in
            return user(with: followLink.0)
        }
    }

    func usersFollowedByUser(with userID: GenericIdentifier<UserProtocol>) -> [UserProtocol]? {
        guard let _ = user(with: userID) else {
            return nil
        }

        return followers.filter { followLink in
            return followLink.0 == userID
        }
        .compactMap { followLink in
            return user(with: followLink.1)
        }
    }
}
