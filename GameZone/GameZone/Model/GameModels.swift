import Foundation

struct GameModels:Decodable{
    let results: [Results]
}

struct Results:Decodable,Equatable{
    let name: String
    let id: Int
    let rating: Double
    let slug: String
    let background_image: String
    let released: String
    
    static func ==(lhs: Results, rhs: Results) -> Bool {
        return lhs.name == rhs.name
    }
}
