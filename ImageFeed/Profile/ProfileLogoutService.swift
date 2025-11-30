import Foundation
import WebKit

final class ProfileLogoutService{
    static let shared = ProfileLogoutService()
    private init(){}
    
    func logout(){
        cleanCookies()
        cleanAvatar()
        cleanProfileData()
        cleanImageList()
        cleanUserToken()
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
        let profileImage = ProfileImageService.shared
        profileImage.deleteAvatarImageUrl()
    }
    
    private func cleanProfileData(){
        let profileService = ProfileService.shared
        profileService.deleteProfile()
    }
    
    private func cleanImageList(){
        let imageListService = ImageListService.shared
        imageListService.deleteAllPhotos()
    }
    
    private func cleanUserToken(){
        let storage = OAuth2TokenStorage.shared
        storage.delete()
    }
}

