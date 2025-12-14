import Foundation

public protocol ImageListPresenterProtocol {
    var view:ImageListViewControllerProtocol? { get set }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func updatePhotoCount()
    func getPhotosCount() -> Int
    func getPhoto(at indexPath: IndexPath) -> Photo
    func changeLike(at indexPath: IndexPath)
    func resetStateForLogout()
}

final class ImageListPresenter: ImageListPresenterProtocol {
    
    var view: ImageListViewControllerProtocol?
    private var photos: [Photo] = []
    private let imageListService: ImageListServiceProtocol
    
    init(imageListService: ImageListServiceProtocol) {
        self.imageListService = imageListService
    }
    
    func viewDidLoad() {
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage(){
        imageListService.fetchPhotosNextPage()
    }
    
    func updatePhotoCount(){
        let oldPhotoCount = photos.count
        let newPhotoCount = imageListService.photos.count
        photos = imageListService.photos
        if oldPhotoCount != newPhotoCount{
            view?.updateTableViewAnimated(oldPhotoCount: oldPhotoCount, newPhotoCount: newPhotoCount)
        }
    }
    
    func getPhotosCount() -> Int{
        return photos.count
    }
    
    func getPhoto(at indexPath: IndexPath) -> Photo {
        return photos[indexPath.row]
    }
    
    func changeLike(at indexPath: IndexPath){
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLiked: photo.isLiked){[weak self] result in
            guard let self else { return }
            defer{
                UIBlockingProgressHUD.dismiss()
            }
            switch result{
            case .success():
                self.photos = self.imageListService.photos
                let newLikeState = !photo.isLiked
                view?.setLike(isLiked: newLikeState, for: indexPath)
            case .failure(let error):
                print("[changeLike]: не удалось установить/убрать лайк с фото \(error.localizedDescription)")
            }
        }
    }
    
    func resetStateForLogout(){
        photos.removeAll()
    }
}
