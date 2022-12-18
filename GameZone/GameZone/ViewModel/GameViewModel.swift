import Foundation
import UIKit

struct GameListViewModel {
    let results : [Game]
    
}
extension GameListViewModel {
    var numberOfSections: Int {
        return results.count
    }
    
    func numberOfRowsInSeciton(_ section:Int) ->Int {
        return results.count
    }
    func gameAtIndex(_ index:Int) -> GameViewModel {
        let game = self.results[index]
        return GameViewModel(game)
    }
}







//MARK: - 1.KISIM
struct GameViewModel {
    private let game: Game
    
}
extension GameViewModel {
    init(_ game: Game){
        self.game = game
    }
}

extension GameViewModel {
    var name : String? {
        return self.game.name
    }
    var rating : Double? {
        return self.game.rating
    }
    var released : String? {
        return self.game.released
    }
    var background_image : String? {
        return self.game.background_image
    }
    
}


