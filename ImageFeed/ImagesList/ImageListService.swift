import UIKit

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
    static let share = ImageListService()
    private init(){}
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    static let didChangeNotification = Notification.Name("ImageListServiceDidChange")
    private var dateFormatter = ISO8601DateFormatter()
    
    func fetchPhotosNextPage(handler: @escaping(Result<[Photo], Error>) -> Void) {
        task?.cancel()
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let request = self.makeURLRequest(for: nextPage) else {
            handler(.failure(NetworkError.invalidRequest))
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
                    handler(.success(self.photos))
                case .failure(let error):
                    print("[fetchPhotosNextPage] : ошибка запроса \(error.localizedDescription) ")
                    handler(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeURLRequest(for page: Int) -> URLRequest? {
        guard let url = URL(string: (Constants.defaultBaseURL.absoluteString + "/photos?page=\(page)")) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }
}
