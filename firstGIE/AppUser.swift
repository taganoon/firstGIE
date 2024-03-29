import Foundation
import Firebase

struct AppUser {
    let userID: String
    let userName: String
    
    init(data: [String: Any]) {
        userID = data["userID"] as? String ?? "karitouroku"
        userName = data["userName"] as? String ?? "匿名"
    }
}
