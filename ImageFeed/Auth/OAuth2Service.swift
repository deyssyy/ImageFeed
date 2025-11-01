import UIKit

final class OAuth2Service{
    static let shared = OAuth2Service()
    private init(){}
    
    private func MakeOAuthTokenRequest(code: String) -> URLRequest?{
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let authTokenURL = urlComponents.url else { return nil }
        
        var request = URLRequest(url: authTokenURL)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void){
        guard let request = self.MakeOAuthTokenRequest(code: code) else {
            handler(.failure(NetworkError.invalidRequest))
            print("Could not create URLRequest")
            return
        }
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let responseBody = try decoder.decode(OAuthResponseBody.self, from: data)
                    handler(.success(responseBody.accessToken))
                } catch {
                    handler(.failure(NetworkError.decodingError(error)))
                    print(error.localizedDescription)
                }
            case .failure(let error):
                handler(.failure(error))
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}

