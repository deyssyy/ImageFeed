import ImageFeed
import Foundation
import UIKit

final class ProfilePresenterSpy: ProfileViewPresenterProtocol{
    var viewDidLoadCalled = false
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateProfile() {
    }
    
    func updateAvatar() {
    }
    
    func aproveLogout() -> UIAlertController {
        return UIAlertController()
    }
}

final class mockProfileService:ProfileServiceProtocol{
    var profile: ImageFeed.Profile?
    
    func fetchProfile(_ token: String, handler: @escaping (Result<ImageFeed.Profile, any Error>) -> Void) {
    }
    
    func deleteProfile() {
    }
}

final class mockProfileImageService:ProfileImageServiceProtocol{
    var avatarImageUrl: String?
    
    func fetchProfileImageUrl(username: String, handler: @escaping (Result<String, any Error>) -> Void) {
    }
    
    func deleteAvatarImageUrl() {
    }
}
