import Foundation

struct Movie: Codable {
    let title: String
    let originalTitle: String
    let originalTitleRomanised: String
    let releaseDate: String
    let description: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case originalTitle = "original_title"
        case originalTitleRomanised = "original_title_romanised"
        case releaseDate = "release_date"
        case description
        case image
    }
}

//BabbleBuddy morning and afternoon
