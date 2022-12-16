import UIKit

class GameListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var relaseLabel: UILabel!
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gameImage.layer.cornerRadius = 7.0
        gameImage.backgroundColor = .darkGray
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
