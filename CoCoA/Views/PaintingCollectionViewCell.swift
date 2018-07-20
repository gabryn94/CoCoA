import UIKit

class PaintingCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PaintingCollectionViewCell"
    
    var painting: Painting? {
        didSet {
            if let painting = painting {
                paintingImageView.image = UIImage(named: painting.imageFilename)
                paintingLabel.text = painting.name
            }
        }
    }
    
    @IBOutlet weak var paintingImageView: UIImageView!
    
    @IBOutlet weak var paintingLabel: UILabel!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        paintingImageView.clipsToBounds = true
////        defaultShadow()
//        paintingImageView.defaultBorder()
//    }
    
}
