import UIKit

enum AuthServiceError: Error{
    case invalidRequest
}

final class OAuth2Service{
    static let shared = OAuth2Service()
    private var task: URLSessionTask?
    private var lastCode: String?
    private init(){}
    
    func fetchOAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void){
        assert(Thread.isMainThread)
        guard lastCode != code else {
            handler(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = self.makeOAuthTokenRequest(code: code) else {
            handler(.failure(NetworkError.invalidRequest))
            print("[MakeOAuthTokenRequest] : Невозможно создать URLRequest")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request){ [weak self] (result: Result<OAuthResponseBody, Error>) in
            defer {
                self?.task = nil
                self?.lastCode = nil
            }
            switch result{
            case .success(let response):
                handler(.success(response.accessToken))
            case .failure(let error):
                print("[fetchOAuthToken], ошибка запроса \(error.localizedDescription)")
                handler(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest?{
        guard var urlComponents = URLComponents(string: Constants.defaultUrlForComponents) else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let authTokenURL = urlComponents.url else { return nil }
        
        var request = URLRequest(url: authTokenURL)
        request.httpMethod = HTTPMethod.post.rawValue
        return request
    }
}

