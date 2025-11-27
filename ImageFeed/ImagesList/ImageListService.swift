import UIKit

struct LikeResponse: Codable{
    let photo: PhotoResult
}

struct PhotoResult: Codable{
    let id: String
    let createdAt: String
    let width: Double
    let height: Double
    let description: String?
    let urls: UrlsReusult
    let likedByUser: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case urls
        case likedByUser = "liked_by_user"
    }
}

struct UrlsReusult: Codable{
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}



final class ImageListService {
    static let shared = ImageListService()
    private init(){}
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let storage = OAuth2TokenStorage.shared
    static let didChangeNotification = Notification.Name("ImageListServiceDidChange")
    private let dateFormatter = ISO8601DateFormatter()
    
    func deleteAllPhotos() {
        photos.removeAll()
    }
    
    func fetchPhotosNextPage() {
        task?.cancel()
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let token = storage.bearerToken else {
            return
        }
        
        guard let request = self.makeURLRequest(for: nextPage, token: token) else {
            print("[makeURLRequest]: невозможно создать URLRequest")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request){[weak self] (result: Result<[PhotoResult],Error>) in
            guard let self else { return }
            defer{
                self.task = nil
            }
            DispatchQueue.main.async {
                switch result{
                case .success(let photoResult):
                    let newPhotos = photoResult.map { photo in
                        let date = self.dateFormatter.date(from: photo.createdAt)
                        return Photo(
                            id: photo.id,
                            size: CGSize(width: photo.width, height: photo.height),
                            createdAt: date,
                            welcomeDescription: photo.description,
                            thumbImageURL: photo.urls.thumb,
                            largeImageURL: photo.urls.full,
                            isLiked: photo.likedByUser
                        )
                    }
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage  = nextPage
                    NotificationCenter.default.post(
                        name: ImageListService.didChangeNotification,
                        object: self,
                        userInfo: nil)
                case .failure(let error):
                    print("[fetchPhotosNextPage] : ошибка запроса \(error.localizedDescription) ")
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeURLRequest(for page: Int, token: String) -> URLRequest? {
        guard let url = URL(string: (Constants.defaultBaseURL.absoluteString + "/photos?page=\(page)")) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeLike(photoId: String, isLiked: Bool,_ handler: @escaping (Result<Void, Error>) -> Void){
        task?.cancel()
        
        guard let token = storage.bearerToken else {
            return
        }
        guard let url = URL(string: (Constants.defaultBaseURL.absoluteString + "/photos/\(photoId)/like")) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = isLiked ? HTTPMethod.delete.rawValue : HTTPMethod.post.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request){[weak self] (result: Result<LikeResponse,Error>) in
            guard let self else { return }
            defer{
                self.task = nil
            }
            DispatchQueue.main.async{
                switch result{
                case .success(_):
                    if let index = self.photos.firstIndex(where: {$0.id == photoId}){
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: !photo.isLiked)
                        self.photos = self.photos.withReplaced(item: newPhoto, at: index)
                    }
                    handler(.success(()))
                case .failure(let error):
                    print("[changeLike]: не удалось установить/убрать лайк с фото \(error.localizedDescription)")
                    handler(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
}

