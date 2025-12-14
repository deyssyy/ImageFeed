import Foundation
import UIKit

public protocol ProfileViewPresenterProtocol {
    func viewDidLoad()
    func updateProfile()
    func updateAvatar()
    func aproveLogout() -> UIAlertController
    var view: ProfileViewControllerProtocol? { get set }
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol{
    
    private let profileService: ProfileServiceProtocol
    private let profileLogoutService: ProfileLogoutServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    
    weak var view: ProfileViewControllerProtocol?
    
    init(profileService: ProfileServiceProtocol,profileImageService: ProfileImageServiceProtocol,profileLogoutService: ProfileLogoutServiceProtocol) {
        self.profileService = profileService
        self.profileLogoutService = profileLogoutService
        self.profileImageService = profileImageService
    }
    
    func viewDidLoad() {
        updateProfile()
        updateAvatar()
    }
    
    func updateProfile(){
        guard let profile = profileService.profile else { return }
        let name = profile.name
        let login = profile.loginName
        let description = (profile.bio?.isEmpty ?? true)
        ? "Описание профиля отсутствует"
        : profile.bio
        view?.displayProfileData(name: name, login: login, description: description ?? "")
    }
    
    func updateAvatar(){
        guard
            let profileImageUrl = profileImageService.avatarImageUrl,
            let url = URL(string: profileImageUrl)
        else { return }
        guard let placeHolder = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.ypGrey,renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large)) else { return }
        view?.displayProfileImage(url: url, placeHolder: placeHolder)
    }
    
    func aproveLogout() -> UIAlertController{
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        let alertActionYes = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else { return }
            alert.dismiss(animated: true)
            self.profileLogoutService.logout()
            self.switchToSplashViewController()
        }
        let alertActionNo = UIAlertAction(title: "Нет", style: .default){_ in
            alert.dismiss(animated: true)
        }
        alert.addAction(alertActionYes)
        alert.addAction(alertActionNo)
        return alert
    }
    
    private func switchToSplashViewController(){
        guard let window = UIApplication.shared.windows.first else {
            print("Invalid window configuration")
            return
        }
        
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}
