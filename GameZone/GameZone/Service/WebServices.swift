import Foundation
import UIKit


class WebServices {
    static let shared = WebServices()
    private var session = URLSession.shared
    
    
    func getGames(genres: String, completion:@escaping ([Game]?) -> ()){
        guard let url = URL(string: "\(API().gameURL)?genres=\(genres)&\(API().apiKey)") else {return}
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
            if let data = data {
                let gameList = try? JSONDecoder().decode(GameList.self, from: data)
                if let gameList = gameList {
                    completion(gameList.results)
                }
            }
        }.resume()
    }
    
    func getDetailGame (id: Int, completion:@escaping (GameDetail?) -> ()){
        guard let url = URL(string: "\(API().gameURL)/\(id)?\(API().apiKey)") else {return}
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
            if let data = data {
                let gameDetail = try? JSONDecoder().decode(GameDetail.self, from: data)
                if let gameDetail = gameDetail {
                    completion(gameDetail)
                }
            }
        }.resume()

    }
    func getSearchGames(query: String, completion:@escaping ([Game]?) -> ()){
        guard let url = URL(string: "\(API().gameURL)?\(API().apiKey)&search=\(query)") else {return}
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
            if let data = data {
                let gameList = try? JSONDecoder().decode(GameList.self, from: data)
                if let gameList = gameList {
                    completion(gameList.results)
                }
            }
        }.resume()
    }
}
