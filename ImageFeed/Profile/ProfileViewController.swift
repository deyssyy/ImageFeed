import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    enum ProfileViewConsatnts{
        static let logoutButtonWHconstraints: CGFloat = 44
        static let logoutButtonTrailingConstraints: CGFloat = -16
        static var nameLabelText = "Екатерина Новикова"
        static var loginLabelText = "@ekaterina_nov"
        static var discriptionLabelText = "Hello, world!"
    }
    
    private var profileImageView: UIImageView!
    private var nameLabel: UILabel!
    private var loginLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logoutButton: UIButton!
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService = ProfileService.shared
    private let profileImage = UIImage(resource: .testProfilePhoto)
    private let logoutButtonImage = UIImage(resource: .logOutButton)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileViewUI()
        view.backgroundColor = .ypBlack
        if let profile = profileService.profile {
            updateProfile(with: profile)
        }
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main){[weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    private func updateProfile(with profile: Profile){
        nameLabel.text = profile.name
        loginLabel.text = profile.username
        descriptionLabel.text = (profile.bio?.isEmpty ?? true)
        ? "Описание профиль отсутствует"
        : profile.bio
    }
    
    private func updateAvatar(){
        guard
            let profileImageUrl = ProfileImageService.shared.avatarImageUrl,
            let url = URL(string: profileImageUrl)
        else { return }
        
        let placeHolder = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.ypGrey,renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
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
        profileImageView = UIImageView(image: profileImage)
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
        nameLabel = UILabel()
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
        loginLabel = UILabel()
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
        descriptionLabel = UILabel()
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
        logoutButton = UIButton.systemButton(
            with: logoutButtonImage,
            target: self,
            action: #selector(Self.loguotButtonTapped)
        )
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
        //TO DO:
    }
}
