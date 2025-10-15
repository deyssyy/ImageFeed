import UIKit

final class ImagesListCell: UITableViewCell{
    static let reusedIdentifier = "ImagesListCell"
    
    private var hasGradient = false
    
    @IBOutlet weak var bottomGradientView: UIView!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeGradient()
        bottomGradientView.updateGradient()
    }
    
    private func makeGradient(){
        if self.hasGradient == false{
            self.hasGradient = true
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bottomGradientView.bounds
            gradientLayer.colors = [
                UIColor.ypBlack.cgColor,
                UIColor.ypBlack30Op.cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
            
            self.bottomGradientView.layer.addSublayer(gradientLayer)
        }
    }
}

extension UIView{
    func updateGradient() {
            guard let gradientLayer = layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer else { return }
            gradientLayer.frame = bounds
        }
}
