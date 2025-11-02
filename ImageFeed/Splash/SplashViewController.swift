import UIKit

final class SplashViewController: UIViewController{
    private let showAuthenticationScreenSegueIdentifire = "showAuthenticationScreenSegueIdentifire"
    private let storage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storage.bearerToken != nil {
            switchToTabBarViewController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifire, sender: nil)
        }
    }
    
    private func switchToTabBarViewController(){
        guard let window = UIApplication.shared.windows.first else {
            print("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifire {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? AuthViewController else {
                print("Ошибка перехода по сегвею showAuthenticationScreenSegueIdentifire")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate{
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToTabBarViewController()
    }
}
