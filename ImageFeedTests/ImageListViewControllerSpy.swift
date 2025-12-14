import ImageFeed
import Foundation

final class ImageListViewControllerSpy: ImageListViewControllerProtocol{
    var presenter: (any ImageFeed.ImageListPresenterProtocol)?
    var updateTableViewAnimatedCalled = false
    var setLikeCalled = false
    
    func updateTableViewAnimated(oldPhotoCount: Int, newPhotoCount: Int) {
        updateTableViewAnimatedCalled = true
    }
    
    func setLike(isLiked: Bool, for indexPath: IndexPath) {
        setLikeCalled = true
    }
}
