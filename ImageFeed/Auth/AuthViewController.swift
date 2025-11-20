import UIKit
import ProgressHUD

final class AuthViewController: UIViewController{
    private let oauth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    weak var delegate: AuthViewControllerDelegate?
    
    private var loginButton: UIButton!
    private var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        setupAuthview()
    }
    
    private func setupAuthview(){
        view.backgroundColor = .ypBlack
        
        let logoImage = UIImage(resource: .logoOfUnsplash)
        logoImageView = UIImageView(image: logoImage)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Войти", for: .normal)
        loginButton.backgroundColor = .white
        loginButton.setTitleColor(.ypBlack, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 16
        loginButton.addTarget(self, action: #selector (loginButtonTap), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
    }
    
    @objc private func loginButtonTap(){
        let webViewController = WebViewViewController()
        webViewController.delegate = self
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    private func configureBackButton(){
        navigationController?.navigationBar.backIndicatorImage = UIImage(resource: .backwardButton)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(resource: .backwardButton)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}

extension AuthViewController: WebViewViewControllerDelegate{
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code: code){ [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            DispatchQueue.main.async{
                switch result{
                case .success(let token):
                    self.oAuth2TokenStorage.bearerToken = token
                    print("Токен авторизации сохранен")
                    self.delegate?.didAuthenticate(self)
                case .failure(let error):
                    print("Ошибка аутентификации:\(error.localizedDescription)")
                    self.showAlert()
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

protocol AuthViewControllerDelegate: AnyObject{
    func didAuthenticate(_ vc: AuthViewController)
}
