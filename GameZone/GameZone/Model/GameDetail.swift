
import Foundation



struct GameDetail: Codable {
    let id: Int
    let name: String
    let released: String
    let backgroundImage: String
    let rating: Double
    let descriptionRaw: String
   

    enum CodingKeys: String, CodingKey {
        case id, name,rating,released
        case backgroundImage = "background_image"
        case descriptionRaw = "description_raw"
    }
}
