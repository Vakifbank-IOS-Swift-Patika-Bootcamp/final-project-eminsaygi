import UIKit
import Kingfisher
import CoreData

class GameDetailVC: UIViewController {
    
    private var isactive: Bool = true
    private var urlString = ""
    var selectedId = 0
    var gameIdArray : [Int]!
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var saveGameButton: UIButton!
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        getDetailData()
        imageView.backgroundColor = .darkGray
        overViewLabel.text = ""
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        guard let gameIdArray = self.gameIdArray else {return}
        
        for id in gameIdArray {
            if id == selectedId {
                isactive = false
                
            }
        }
        if isactive == false {
            isButtonActive()
            
        }
        
    }
    
    private func isButtonActive(){
        isButtonImage(imageName: "checkmark.circle.fill")
        saveGameButton.isEnabled = false
    }
    
    
    @IBAction private func saveFavouriteButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let saveData = NSEntityDescription.insertNewObject(forEntityName: "GamesData", into: context)
        
        saveData.setValue(titleLabel.text, forKey: "title")
        saveData.setValue(releaseLabel.text, forKey: "releaseDate")
        saveData.setValue(voteAverageLabel.text, forKey: "voteCount")
        saveData.setValue(urlString, forKey: "image")
        saveData.setValue(UUID(), forKey: "id")
        saveData.setValue(selectedId, forKey: "gameId")
        
        do {
            if isactive {
                
                try context.save() // Telefonu yeniden başlatınca kaydetmeyi sağlıyor
                savedAlert(title: "Succes", message: "Congratulations. Successfully Saved")
                isButtonImage(imageName: "checkmark.circle.fill")
                saveGameButton.isEnabled = false
                
            }
            
        } catch {
            print("Catch: GameDetail.swift : saveFavouriteButton")
            
        }
        
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "newData"), object: nil)
        
        
    }
    private func isButtonImage(imageName: String){
        saveGameButton.setImage(UIImage(systemName: imageName), for: .normal)
        
        
    }
    
    private func savedAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler:  nil)
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    
}


extension GameDetailVC {
    
    private func getDetailData(){
        WebServices.shared.getDetailGame(id: selectedId){ result in
            
            
            
            DispatchQueue.main.async {
                self.titleLabel.text = result?.name
                self.releaseLabel.text = result?.released
                self.overViewLabel.text = result?.descriptionRaw
                let voteAveragaText = Utils.convertDouble(result!.rating, maxDecimals: 1)
                self.voteAverageLabel.text = "\(voteAveragaText)/10"
                
                self.urlString = result?.backgroundImage ?? ""
                let url = URL(string: self.urlString)
                self.imageView.kf.setImage(with: url)
            }
        }
    }
}
