import UIKit
import DropDown
import CoreData

class GameListVC: UIViewController, UISearchResultsUpdating {
    private let dropDown = DropDown()
    private let typeGame = TypeCategoryGame()
    private var selectedId = 0
    private var gameIdArray = [Int]()
    public var langString = ""
    private var gameListVM: GameListViewModel!
    
    
    
    @IBOutlet weak private var gameListTable: UITableView!
    @IBOutlet weak private var viewDropDown: UIView!
    @IBOutlet weak private var lblTitle: UILabel!
    
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        gameListTable.delegate = self
        gameListTable.dataSource = self
        
        refreshControl()
        
        getGameData(type: typeGame.action)
        
        
    }
    
    
    private func getCoreData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GamesData")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    
                    if let gameId = result.value(forKey: "gameId") as? Int {
                        gameIdArray.append(gameId)
                        
                    }
                    
                }
            }
            
        } catch {
            print("ErrorCatch: getCoreData : \(error.localizedDescription)")
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCoreData()
        DropDownListOptions()
        searchController()
    }
    
    // View ekranı oluştuktan hemen sonra çağrılır.
    override func viewDidAppear(_ animated: Bool) {
        getGameData(type: typeGame.action)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC"  {
            let detailVC = segue.destination as? GameDetailVC
            detailVC?.selectedId = selectedId
            detailVC?.gameIdArray = gameIdArray
            
            
        }
    }
    
    
    
}

extension GameListVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.gameListVM == nil ? 0 : self.gameListVM.numberOfSections
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameListVM.numberOfRowsInSeciton(section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = gameListTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameListTableViewCell
        
        let gameVM = gameListVM.gameAtIndex(indexPath.row)
        cell.titleLabel.text = gameVM.name
        cell.voteAverageLabel.text = "\(gameVM.rating!)"
        
        cell.relaseLabel.text = gameVM.released
        
        
        
        let url = URL(string: gameVM.background_image!)!
        
        DispatchQueue.main.async {
            cell.gameImage.kf.setImage(with: url)
        }
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedId = gameListVM.results[indexPath.row].id ?? 0
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toDetailVC", sender: nil)
            
        }
    }
    
    
}




extension GameListVC {
    
    func getGameData(type : String){
        WebServices.shared.getGames(genres: type) { results in
            
            if let results = results {
                self.gameListVM = GameListViewModel(results: results)
                
                DispatchQueue.main.async {
                    self.gameListTable.reloadData()
                }
                
            }
            
        }
    }
    
    
    
}



extension GameListVC {
    
    
    private func DropDownListOptions() {
        let categoryGame = ["\(langChange(str: "Action", lang: Utils.shared.lang))","\(langChange(str: "Racing", lang: Utils.shared.lang))","\(langChange(str: "Shotter", lang: Utils.shared.lang))","\(langChange(str: "Adventure", lang: Utils.shared.lang))","\(langChange(str: "Fighting", lang: Utils.shared.lang))"]
        
        lblTitle.text = "\(langChange(str: "Action", lang: Utils.shared.lang))"
        
        dropDown.anchorView = viewDropDown
        dropDown.dataSource = categoryGame
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            switch item {
            case "\(langChange(str: "Action", lang: Utils.shared.lang))":
                getGameData(type: typeGame.action)
            case "\(langChange(str: "Racing", lang: Utils.shared.lang))":
                getGameData(type: typeGame.racing)
            case "\(langChange(str: "Shotter", lang: Utils.shared.lang))":
                getGameData(type: typeGame.shooter)
            case "\(langChange(str: "Adventure", lang: Utils.shared.lang))":
                getGameData(type: typeGame.adventure)
            case "\(langChange(str: "Fighting", lang: Utils.shared.lang))":
                getGameData(type: typeGame.fighting)
            default:
                getGameData(type: typeGame.action)
                
            }
            self.lblTitle.text = categoryGame[index]
            
        }
        
    }
    
    
    @IBAction func showCategoryOptions(_ sender: Any) {
        dropDown.show()
    }
}

//MARK: - Arama işlemleri

extension GameListVC{
    
    private func searchController(){
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = langChange(str: "Type something here to search game", lang: Utils.shared.lang)
        navigationItem.searchController = search
        
        
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 1 {
            let query = Utils.searchStringEdited(query: text)
            
            
            
            WebServices.shared.getSearchGames(query: query) { results in
                
                if let results = results {
                    self.gameListVM = GameListViewModel(results: results)
                    
                    DispatchQueue.main.async {
                        self.gameListTable.reloadData()
                    }
                    
                }
                
            }
        }
    }
    
}

//MARK: - Refresh Control Section

extension GameListVC{
    
    func refreshControl(){
        gameListTable.refreshControl = UIRefreshControl()
        gameListTable.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    
    @objc private func didPullToRefresh(){
        
        getGameData(type: typeGame.action)
        lblTitle.text = "\(langChange(str: "Action", lang: Utils.shared.lang))"
        gameListTable.refreshControl?.endRefreshing()
    }
    
}
