import Foundation
import WebKit

public protocol ProfileLogoutServiceProtocol {
    func logout()
}

final class ProfileLogoutService: ProfileLogoutServiceProtocol{
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let imageListService: ImageListServiceProtocol
    static let didLogoutNotification = Notification.Name("LogoutServiceDidLogout")
    
    init(profileService: ProfileServiceProtocol, profileImageService: ProfileImageServiceProtocol, ImageListService: ImageListServiceProtocol, OAuth2TokenStorage: OAuth2TokenStorage = OAuth2TokenStorage.shared) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.imageListService = ImageListService
    }
    
    func logout(){
        cleanCookies()
        cleanAvatar()
        cleanProfileData()
        cleanImageList()
        cleanUserToken()
        
        NotificationCenter.default.post(
            name: ProfileLogoutService.didLogoutNotification,
            object: self,
            userInfo: nil)
    }
    
    private func cleanCookies(){
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()){records in
            records.forEach{record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record],completionHandler: {})
            }
        }
    }
    
    private func cleanAvatar(){
        profileImageService.deleteAvatarImageUrl()
    }
    
    private func cleanProfileData(){
        profileService.deleteProfile()
    }
    
    private func cleanImageList(){
        imageListService.deleteAllPhotos()
    }
    
    private func cleanUserToken(){
        let storage = OAuth2TokenStorage.shared
        storage.delete()
    }
}

