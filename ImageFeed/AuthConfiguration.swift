import UIKit
enum Constants{
    static let accessKey = "rEmHKikW8TPB6bCFqX2qLbm9pljZChNaPZDKg3UDqoE"
    static let secretKey = "C3bkncjNIqIN3EGDqwP1ZvxnQQtMhnP6WBmVlRHpA0s"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashUrlComponentPath = "/oauth/authorize/native"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let defaultUrlForComponents = "https://unsplash.com/oauth/token"
}

struct AuthConfiguration{
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    
    let unsplashAuthorizeURLString: String
    let unsplashUrlComponentPath: String
    let defaultBaseURL: URL
    let defaultUrlForComponents: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, unsplashAuthorizeURLString: String, unsplashUrlComponentPath: String, defaultBaseURL: URL, defaultUrlForComponents: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
        self.unsplashUrlComponentPath = unsplashUrlComponentPath
        self.defaultBaseURL = defaultBaseURL
        self.defaultUrlForComponents = defaultUrlForComponents
    }
    
    static var standart: AuthConfiguration{
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            unsplashAuthorizeURLString: Constants.unsplashAuthorizeURLString,
            unsplashUrlComponentPath: Constants.unsplashUrlComponentPath,
            defaultBaseURL: Constants.defaultBaseURL,
            defaultUrlForComponents: Constants.defaultUrlForComponents)
    }
}
