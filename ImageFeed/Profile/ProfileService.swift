import Foundation

struct ProfileResult: Codable{
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

final class ProfileService{
    static let shared = ProfileService()
    private init(){}
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    private func MakeProfileRequest(token: String) -> URLRequest?{
        guard let url = URL(string: (Constants.defaultBaseURL.absoluteString + "/me")) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, handler: @escaping(Result<Profile, Error>) -> Void){
        task?.cancel()
        
        guard let request = self.MakeProfileRequest(token: token) else {
            handler(.failure(NetworkError.invalidRequest))
            print("[MakeProfileRequest] : Невозможно создать URLRequest")
            return
        }
        let task = URLSession.shared.objectTask(for: request){[weak self] (result: Result<ProfileResult,Error>) in
            defer{
                self?.task = nil
            }
            switch result{
            case .success(let profileResult):
                let name = profileResult.firstName + " " + profileResult.lastName
                let profile = Profile(
                    username: profileResult.username,
                    name: name,
                    bio: profileResult.bio)
                self?.profile = profile
                handler(.success(profile))
            case .failure(let error):
                print("[fetchProfile] : ошибка запроса \(error.localizedDescription)")
                handler(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
}
