import UIKit
enum Constants{
    static let accessKey = "rEmHKikW8TPB6bCFqX2qLbm9pljZChNaPZDKg3UDqoE"
    static let secretKey = "C3bkncjNIqIN3EGDqwP1ZvxnQQtMhnP6WBmVlRHpA0s"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}

enum ProfileViewContsatnts{
    static let logoutButtonWHconstraints: CGFloat = 44
    static let logoutButtonTrailingConstraints: CGFloat = -16
    static let nameLabelText = "Екатерина Новикова"
    static let loginLabelText = "@ekaterina_nov"
    static let discriptionLabelText = "Hello, world!"
}
