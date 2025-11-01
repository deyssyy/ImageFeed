import UIKit

final class AuthViewController: UIViewController{
    
    private let webViewSegueID = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    private func configureBackButton(){
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackwardButton")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackwardButton")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == webViewSegueID {
            guard let vc = segue.destination as? WebViewViewController else { return }
            vc.delegate = self
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate{
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oauth2Service.fetchOAuthToken(code: code){ [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async{
                switch result{
                case .success(let token):
                    self.oAuth2TokenStorage.bearerToken = token
                    print("Токен авторизации сохранен")
                    self.delegate?.didAuthenticate(self)
                case .failure(let error):
                    print(error.localizedDescription)
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
