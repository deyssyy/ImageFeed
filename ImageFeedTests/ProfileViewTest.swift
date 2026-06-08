@testable import ImageFeed
import XCTest

final class ProfileViewTest: XCTestCase {
    
    func testViewControllerCallsViewDidLoad(){
        let profileViewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        presenter.view = profileViewController
        profileViewController.presenter = presenter
        
        _ = profileViewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testUpadteProfileBioNotNil(){
        let mockProfileService = mockProfileService()
        mockProfileService.profile = Profile(username: "testUserName", name: "testName", bio: "testBio")
        let profileViewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter(profileService: mockProfileService, profileImageService: ProfileImageService(), profileLogoutService: ProfileLogoutServiceSpy())
        
        profileViewController.presenter = presenter
        presenter.view = profileViewController
        
        presenter.updateProfile()
        
        XCTAssertEqual(profileViewController.testLogin, "@testUserName")
        XCTAssertEqual(profileViewController.testName, "testName")
        XCTAssertEqual(profileViewController.testDescription, "testBio")
    }
    
    func testUpadteProfileBioNil(){
        let mockProfileService = mockProfileService()
        mockProfileService.profile = Profile(username: "testUserName", name: "testName", bio: nil)
        let profileViewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter(profileService: mockProfileService, profileImageService: ProfileImageService(), profileLogoutService: ProfileLogoutServiceSpy())
        
        profileViewController.presenter = presenter
        presenter.view = profileViewController
        
        presenter.updateProfile()
        
        XCTAssertEqual(profileViewController.testLogin, "@testUserName")
        XCTAssertEqual(profileViewController.testName, "testName")
        XCTAssertEqual(profileViewController.testDescription, "Описание профиля отсутствует")
    }
    
    func testUpdateAvatarImagewithImageUrl(){
        let mockProfileImageService = mockProfileImageService()
        mockProfileImageService.avatarImageUrl = "https://example.com/image"
        let vc = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter(profileService: mockProfileService(), profileImageService: mockProfileImageService, profileLogoutService: ProfileLogoutServiceSpy())
        
        presenter.view = vc
        vc.presenter = presenter
        
        presenter.updateAvatar()
        
        XCTAssertTrue(vc.testURL?.absoluteString == "https://example.com/image")
        XCTAssertNotNil(vc.placeholder)
    }
    
    func testUpdateAvatarImagewithNilImageUrl(){
        let mockProfileImageService = mockProfileImageService()
        let vc = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter(profileService: mockProfileService(), profileImageService: mockProfileImageService, profileLogoutService: ProfileLogoutServiceSpy())
        
        presenter.view = vc
        vc.presenter = presenter
        
        presenter.updateAvatar()
        
        XCTAssertNil(vc.testURL)
        XCTAssertNil(vc.placeholder)
    }
}
