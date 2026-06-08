import Foundation
@testable import ImageFeed

final class ImageListPresenterSpy:ImageListPresenterProtocol{
    var view: ImageFeed.ImageListViewControllerProtocol?
    var viewDidLoadCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        
    }
    
    func updatePhotoCount() {
        
    }
    
    func getPhotosCount() -> Int {
        return 0
    }
    
    func getPhoto(at indexPath: IndexPath) -> ImageFeed.Photo {
        let photo = ImageFeed.Photo(id: "1", size: CGSize(width: 1, height: 1), createdAt: nil, welcomeDescription: "nil", thumbImageURL: "", largeImageURL: "", isLiked: true)
        return photo
    }
    
    func changeLike(at indexPath: IndexPath) {
        
    }
    
    func resetStateForLogout() {
    }
}

final class mockImageListService:ImageListServiceProtocol{
    var photos: [ImageFeed.Photo] = []
    var fetchPhotosNextPageCalled = false
    var changeLikeCalled = false
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func deleteAllPhotos() {
    }
    
    func changeLike(photoId: String, isLiked: Bool, _ handler: @escaping (Result<Void, any Error>) -> Void) {
        changeLikeCalled = true
        if let index = photos.firstIndex(where: {$0.id == photoId}){
            let oldPhoto = photos[index]
            let newPhoto = Photo(id: oldPhoto.id, size: oldPhoto.size, createdAt: oldPhoto.createdAt, welcomeDescription: oldPhoto.welcomeDescription, thumbImageURL: oldPhoto.thumbImageURL, largeImageURL: oldPhoto.largeImageURL, isLiked: !oldPhoto.isLiked)
            photos[index] = newPhoto
        }
        handler(.success(()))
    }
}
