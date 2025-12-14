import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol{
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var isLoadingCalled = false
    
    func load(request: URLRequest) {
        isLoadingCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
}
