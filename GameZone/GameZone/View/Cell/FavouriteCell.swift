import UIKit

class FavouriteCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var relaseLabel: UILabel!
    
    @IBOutlet weak var gameFavImage: UIImageView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        gameFavImage.layer.cornerRadius = 7.0
        gameFavImage.backgroundColor = .darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    

}
