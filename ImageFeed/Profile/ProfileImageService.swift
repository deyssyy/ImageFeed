import Foundation

struct ProfileImage: Codable{
    let small: String
    let medium: String
    let large: String
}

struct UserResult: Codable{
    let profileImage: ProfileImage
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

final class ProfileImageService{
    static let shared = ProfileImageService()
    private init(){}
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    private let storage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private(set) var avatarImageUrl: String?
    
    private func MakeProfilePhotoRequest(username: String, token: String) -> URLRequest?{
        guard let url = URL(string: (Constants.defaultBaseURL.absoluteString + "/users/\(username)")) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageUrl(username: String, handler: @escaping(Result<String, Error>) -> Void){
        task?.cancel()
        
        guard let token = storage.bearerToken else {
            handler(.failure(NSError(domain: "ProfileImageService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authorization token missing"])))
            return
        }
        
        guard let request = self.MakeProfilePhotoRequest(username: username, token: token) else {
            handler(.failure(NetworkError.invalidRequest))
            print("[MakeProfilePhotoRequest] : Невозможно создать URLRequest")
            return
        }
        let task = URLSession.shared.objectTask(for: request){ [weak self] (result: Result<UserResult, Error>) in
            defer{
                self?.task = nil
            }
            switch result{
            case .success(let profileResult):
                let imageUrl = profileResult.profileImage.small
                print(imageUrl)
                self?.avatarImageUrl = imageUrl
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": imageUrl])
                handler(.success(imageUrl))
            case .failure(let error):
                print("[fetchProfileImageUrl] : ошибка запроса \(error.localizedDescription) ")
                handler(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
}
