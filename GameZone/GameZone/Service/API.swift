import Foundation

class API {
     var baseURL: String {
        return "https://api.rawg.io"
    }
     var gameURL: String {
        
        return "\(baseURL)/api/games"
    }
     let apiKey = "key=efd5fbffb5c9441facda55cb48841354"
}

struct TypeCategoryGame  {
     let racing = "racing"
     let shooter = "shooter"
     let adventure = "adventure"
     let action = "action"
     let fighting = "fighting"
    
}
