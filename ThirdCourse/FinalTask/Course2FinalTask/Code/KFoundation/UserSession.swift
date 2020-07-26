import DataProvider
import Foundation
import BrightFutures

class UserSession {
    static let shared = UserSession()

    var currentUser: User?

    private init() { }

    func getUser() {
        KDataProvider.currentUser()
            .onSuccess { [weak self] user in
                self?.currentUser = user
        }
        .onFailure { error in }
    }
}
