import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageListViewController = ImagesListViewController()
        
        imageListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabEditoralActive),
            selectedImage: nil)
        
        let profileViewController = ProfileViewController()
        
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


