struct Profile{
    let username: String
    let name: String
    var loginName: String{
        return "@" + username
    }
    let bio: String?
}
