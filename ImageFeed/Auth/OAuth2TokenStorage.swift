import Foundation

final class OAuth2TokenStorage{
    private let storage: UserDefaults = .standard
    
    enum Key: String{
        case bearerToken = "bearerToken"
    }
    
    var bearerToken: String?{
        get{
            storage.string(forKey: Key.bearerToken.rawValue)
        }
        set{
            storage.set(newValue, forKey: Key.bearerToken.rawValue)
        }
    }
}
