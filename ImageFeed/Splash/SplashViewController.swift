import UIKit

final class SplashViewController: UIViewController{
    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = storage.bearerToken {
            fetchProfile(token)
        } else {
            presentAuthViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashView()
    }
    
    private func setupSplashView(){
        view.backgroundColor = .ypBlack
        
        let imageView = UIImageView(image: UIImage(resource: .launchScreenLogo))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 77.68),
            imageView.widthAnchor.constraint(equalToConstant: 75),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func switchToTabBarViewController(){
        guard let window = UIApplication.shared.windows.first else {
            print("Invalid window configuration")
            return
        }
        
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
}

extension SplashViewController{
    private func presentAuthViewController() {
        let authViewController = AuthViewController()
        let navigationViewController = UINavigationController(rootViewController: authViewController)
        authViewController.delegate = self
        navigationViewController.modalPresentationStyle = .fullScreen
        present(navigationViewController, animated: true)
    }
}

extension SplashViewController: AuthViewControllerDelegate{
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        guard let token = storage.bearerToken else { return }
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String){
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token){[weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case let .success(profile):
                ProfileImageService.shared.fetchProfileImageUrl(username: profile.username){_ in }
                self.switchToTabBarViewController()
            case let .failure(error):
                print(error.localizedDescription)
                break
            }
        }
    }
}
