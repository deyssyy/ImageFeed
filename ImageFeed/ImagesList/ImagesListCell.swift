import UIKit

final class ImagesListCell: UITableViewCell{
    static let reusedIdentifier = "ImagesListCell"
    
    private let gradientLayer = CAGradientLayer()
    
    let bottomGradientView = UIView()
    let imageCell = UIImageView()
    let dateLabel = UILabel()
    let likeButton = UIButton(type: .custom)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bottomGradientView.bounds
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        makeGradient()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupCell(){
        self.backgroundColor = .clear
        contentView.backgroundColor = .ypBlack
        
        imageCell.clipsToBounds = true
        imageCell.layer.cornerRadius = 16
        imageCell.contentMode = .scaleAspectFill
        
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = .white
        
        bottomGradientView.layer.opacity = 0.4
        
        bottomGradientView.translatesAutoresizingMaskIntoConstraints = false
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageCell)
        contentView.addSubview(bottomGradientView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.topAnchor.constraint(equalTo: imageCell.topAnchor, constant: 0),
            likeButton.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor, constant: 0),
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -4),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            imageCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(greaterThanOrEqualTo: imageCell.trailingAnchor, constant: -8),
            bottomGradientView.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor),
            bottomGradientView.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor),
            bottomGradientView.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor),
            bottomGradientView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func makeGradient(){
        gradientLayer.colors = [
            UIColor.ypBlack.cgColor,
            UIColor.ypBlack30Op.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        
        self.bottomGradientView.layer.addSublayer(gradientLayer)
    }
}

extension UIView{
    func updateGradient() {
        guard let gradientLayer = layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer else { return }
        gradientLayer.frame = bounds
    }
}
