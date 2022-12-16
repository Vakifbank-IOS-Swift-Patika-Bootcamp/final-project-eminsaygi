
import Foundation
import UIKit

struct GameList : Decodable{
    let results : [Game]
}
struct Game : Decodable {
    var id : Int?
    var name : String?
    var rating : Double?
    var released : String?
    var background_image : String?
}
