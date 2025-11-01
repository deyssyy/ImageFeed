struct OAuthResponseBody: Decodable{
    let accessToken: String
    let tokenType: String
    let scope: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.tokenType = try container.decode(String.self, forKey: .tokenType)
        self.scope = try container.decode(String.self, forKey: .scope)
    }
}
