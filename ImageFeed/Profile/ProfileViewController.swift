import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    func displayProfileData(name: String, login: String, description: String)
    func displayProfileImage(url: URL, placeHolder: UIImage)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    enum ProfileViewConsatnts{
        static let logoutButtonWHconstraints: CGFloat = 44
        static let logoutButtonTrailingConstraints: CGFloat = -16
        static var nameLabelText = "Екатерина Новикова"
        static var loginLabelText = "@ekaterina_nov"
        static var discriptionLabelText = "Hello, world!"
    }
    
    var presenter: ProfileViewPresenterProtocol?
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logoutButton = UIButton(type: .custom)
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileImage = UIImage(resource: .testProfilePhoto)
    private let logoutButtonImage = UIImage(resource: .logOutButton)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileViewUI()
        view.backgroundColor = .ypBlack
        presenter?.viewDidLoad()
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main){[weak self] _ in
                guard let self else { return }
                self.presenter?.updateAvatar()
            }
    }
    
    func displayProfileData(name: String, login: String, description: String) {
        nameLabel.text = name
        loginLabel.text = login
        descriptionLabel.text = description
    }
    
    func displayProfileImage(url: URL, placeHolder: UIImage) {
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(
            with: url,
            placeholder: placeHolder,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]){ result in
                switch result{
                case .success(let value):
                    print(value.image)
                    print(value.cacheType)
                    print(value.source)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    private func setupProfileViewUI(){
        configureProfileImageView()
        configureNameLabel()
        configureLoginLable()
        configureDescriptionLabel()
        configureLogoutButton()
    }
    
    private func configureProfileImageView(){
        profileImageView.image = profileImage
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func configureNameLabel(){
        nameLabel.text = ProfileViewConsatnts.nameLabelText
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo:profileImageView.bottomAnchor , constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
        ])
    }
    
    private func configureLoginLable(){
        loginLabel.text = ProfileViewConsatnts.loginLabelText
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = .ypGrey
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }
    
    private func configureDescriptionLabel(){
        descriptionLabel.text = ProfileViewConsatnts.discriptionLabelText
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }
    
    private func configureLogoutButton(){
        logoutButton.accessibilityIdentifier = "LogoutButton"
        logoutButton.setImage(logoutButtonImage, for: .normal)
        logoutButton.addTarget(self, action: #selector (loguotButtonTapped), for: .touchUpInside)
        logoutButton.tintColor = .ypRed
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: ProfileViewConsatnts.logoutButtonTrailingConstraints),
            logoutButton.widthAnchor.constraint(equalToConstant: ProfileViewConsatnts.logoutButtonWHconstraints),
            logoutButton.heightAnchor.constraint(equalToConstant: ProfileViewConsatnts.logoutButtonWHconstraints)
        ])
    }
    
    @objc private func loguotButtonTapped() {
        guard let alert = presenter?.aproveLogout() else { return }
        present(alert, animated: true)
    }
}
