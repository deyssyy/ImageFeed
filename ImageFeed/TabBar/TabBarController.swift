import UIKit

class MyTabBarController: UITabBarController{
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: "imageListViewIdentifier")
        
        imageListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "TabEditoralActive"),
            selectedImage: nil)
        
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "profileViewIdentifier")
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "TabProfileActive"),
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
