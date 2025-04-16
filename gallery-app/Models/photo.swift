import Foundation

struct URLs: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

struct Photo: Codable {
    let id: String
    let altDescription: String?
    let description: String?
    let urls: URLs

    enum CodingKeys: String, CodingKey {
        case id
        case altDescription = "alt_description"
        case description
        case urls
    }
}
