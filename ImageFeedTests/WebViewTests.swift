@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad(){
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest(){
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let viewController = WebViewViewControllerSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.isLoadingCalled)
    }
    
    func testProgressVisibleWhenLessThenOne(){
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne(){
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL(){
        let configuration = AuthConfiguration.standart
        let authHelper = AuthHelper(configuration: configuration)
        
        let url = authHelper.authURL()
        guard let urlString = url?.absoluteString else { return }
        
        XCTAssertTrue(urlString.contains(configuration.unsplashAuthorizeURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
        XCTAssertTrue(urlString.contains("code"))
    }
    
    func testCodeFromURL(){
        guard var urlComponents = URLComponents(string: "https://api.unsplash.com/oauth/authorize/native") else { return }
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        guard let url = urlComponents.url else { return }
        let config = AuthConfiguration.standart
        let authHelper = AuthHelper(configuration: config)
        
        guard let code = authHelper.code(from: url) else { return }
        
        XCTAssertEqual("test code", code)
    }
}
