import UIKit

final class TabBarController: UITabBarController {
    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    private let imageListService: ImageListService
    private let profileLogoutService: ProfileLogoutService
    
    init(profileService: ProfileService,profileImageService: ProfileImageService,imageListService: ImageListService,profileLogoutService: ProfileLogoutService) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.imageListService = imageListService
        self.profileLogoutService = profileLogoutService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.accessibilityIdentifier = "TabBar"
        
        let imageListViewController = ImagesListViewController()
        let imageListPresenter = ImageListPresenter(imageListService: imageListService)
        imageListViewController.presenter = imageListPresenter
        imageListPresenter.view = imageListViewController
        
        imageListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabEditoralActive),
            selectedImage: nil)
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfileViewPresenter(profileService: profileService,profileImageService: profileImageService,profileLogoutService: profileLogoutService)
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil)
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ypBlack
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        tabBar.tintColor = .white
        
        self.viewControllers = [imageListViewController,profileViewController]
    }
}


