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
