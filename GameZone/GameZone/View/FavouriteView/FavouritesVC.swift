import UIKit
import CoreData
import Kingfisher

class FavouritesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var titleArray = [String]()
    public var gameIdArray = [Int]()
    private var relaseDateArray = [String]()
    private var gameImageArray = [String]()
    private var voteAverageArray = [String]()
    private var idArray = [UUID]()
    
    
    private var selectedId = 0
    
    @IBOutlet weak var favouritesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favouritesTable.delegate = self
        favouritesTable.dataSource = self
        
        getData()
        
        
        
    }
    
    
    //UI Ekranı başlamadan hemen önce çağrılır.
    override func viewWillAppear(_ animated: Bool) {
        // Bir gözlemci tanımladık. Haberciden gelecek verileri işleyecek.
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FavouriteCell = favouritesTable.dequeueReusableCell(withIdentifier: "favouritesCell", for: indexPath) as! FavouriteCell
        
        cell.titleLabel.text = titleArray[indexPath.row]
        cell.relaseLabel.text = relaseDateArray[indexPath.row]
        cell.voteAverageLabel.text = voteAverageArray[indexPath.row]
        let url = URL(string: gameImageArray[indexPath.row])
        cell.gameFavImage.kf.setImage(with: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedId = gameIdArray[indexPath.row]
        performSegue(withIdentifier: "toFavDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFavDetailVC"  {
            let detailVC = segue.destination as? GameDetailVC
            detailVC?.selectedId = selectedId
            detailVC?.gameIdArray = gameIdArray
            
            
        }
      
    }
    
    
    
    
}
extension FavouritesVC {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GamesData")
        
        let idString = idArray[indexPath.row].uuidString
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        
        fetchRequest.returnsObjectsAsFaults = false // Büyük data verilerini okurken hız sağlıyor.
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let _ = result.value(forKey: "id") as? UUID {
                    context.delete(result)
                    
                    idArray.remove(at: indexPath.row)
                    gameIdArray.remove(at: indexPath.row)
                    titleArray.remove(at: indexPath.row)
                    gameImageArray.remove(at: indexPath.row)
                    relaseDateArray.remove(at: indexPath.row)
                    voteAverageArray.remove(at: indexPath.row)
                    
                    self.favouritesTable.reloadData()
                    
                    do  {
                        try context.save()
                    } catch {
                        print("Catch: FavouritesVC.swift : NSManagedObject")
                    }
                    break
                }
            }
        } catch {
            print("Catch: FavouritesVC.swift : commit editingStyle")
            
        }
        
    }
}

extension FavouritesVC {
    
    @objc private func getData(){
        titleArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        gameIdArray.removeAll(keepingCapacity: false)
        gameImageArray.removeAll(keepingCapacity: false)
        voteAverageArray.removeAll(keepingCapacity: false)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GamesData")
        fetchRequest.returnsObjectsAsFaults = false 
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    
                    if let title = result.value(forKey: "title") as? String {
                        titleArray.append(title)
                        
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        idArray.append(id)
                        
                    }
                    
                    if let gameId = result.value(forKey: "gameId") as? Int {
                        gameIdArray.append(gameId)
                        
                    }
                    if let relaseDate = result.value(forKey: "releaseDate") as? String {
                        relaseDateArray.append(relaseDate)
                        
                    }
                    if let gameImage = result.value(forKey: "image") as? String {
                        gameImageArray.append(gameImage)
                        
                    }
                    
                    if let voteAverage = result.value(forKey: "voteCount") as? String {
                        
                        self.voteAverageArray.append(voteAverage)
                        
                    }
                    
                    
                    self.favouritesTable.reloadData()
                }
            }
            
        } catch {
            print("Catch: FavouritesVC.swift : DataList")
            
        }
    }
}


