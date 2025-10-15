import UIKit

final class ProfileViewController: UIViewController {
    
    private var profileImageView: UIImageView!
    private var nameLabel: UILabel!
    private var loginLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logoutButton: UIButton!
    
    private let profileImage = UIImage(named: "TestProfilePhoto")
    private let logoutButtonImage = UIImage(named: "LogOutButton")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileViewUI()
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
        nameLabel.text = "Екатерина Новикова"
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
        loginLabel.text = "@ekaterina_nov"
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
        descriptionLabel.text = "Hello, world!"
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
            with: logoutButtonImage!,
            target: self,
            action: #selector(Self.loguotButtonTapped)
        )
        logoutButton.tintColor = .ypRed
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
    
    @objc private func loguotButtonTapped() {
        //TO DO:
    }
}
