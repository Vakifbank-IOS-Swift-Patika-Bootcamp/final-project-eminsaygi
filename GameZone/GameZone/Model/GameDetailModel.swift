import Foundation

struct GameDetailModel: Decodable{
    let id: Int?
    let name: String?
    let description: String?
    let released: String?
    let rating: Double?
    let background_image: String?
    
    public init(id:Int? = nil,name: String? = nil,description: String? = nil,released: String? = nil,rating: Double? = nil,background_image: String? = nil) {
        self.id = id
        self.name = name
        self.description = name
        self.rating = rating
        self.released = released
        self.background_image = background_image
    }
    
}
