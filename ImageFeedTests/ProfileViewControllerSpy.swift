import ImageFeed
import Foundation
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol{
    var testName = ""
    var testLogin = ""
    var testDescription = ""
    var testURL: URL?
    var placeholder: UIImage?
    var presenter: ProfileViewPresenterProtocol?
    
    func displayProfileData(name: String, login: String, description: String) {
        testName = name
        testLogin = login
        testDescription = description
    }
    
    func displayProfileImage(url: URL, placeHolder: UIImage) {
        testURL = url
        placeholder = placeHolder
    }
}
