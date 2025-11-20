import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage{
    static let shared = OAuth2TokenStorage()
    private init(){}
    private let storage: KeychainWrapper = .standard
    
    enum Key: String{
        case bearerToken = "bearerToken"
    }
    
    func delete(){
        storage.removeObject(forKey: Key.bearerToken.rawValue)
    }
    
    var bearerToken: String?{
        get{
            storage.string(forKey: Key.bearerToken.rawValue)
        }
        set{
            if let newValue = newValue{
                storage.set(newValue, forKey: Key.bearerToken.rawValue)
            } else {
                storage.removeObject(forKey: Key.bearerToken.rawValue)
            }
        }
    }
}
