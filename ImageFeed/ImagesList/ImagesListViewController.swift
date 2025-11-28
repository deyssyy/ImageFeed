import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    private let tableView = UITableView()
    private let service = ImageListService.shared
    private var photos: [Photo] = []
    private var imageListServiceObserver: NSObjectProtocol?
    
    private enum ButtonIcons: String{
        case LikeButtonOn
        case LikeButtonOff
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main){[weak self] _ in
                guard let self else { return }
                self.updateTableViewAnimated()
            }
        service.fetchPhotosNextPage()
    }
    
    private func setupTableView(){
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reusedIdentifier)
        tableView.backgroundColor = .ypBlack
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func updateTableViewAnimated(){
        let oldPhotoCount = photos.count
        let newPhotoCount = service.photos.count
        photos = service.photos
        if oldPhotoCount != newPhotoCount{
            tableView.performBatchUpdates {
                let indexPaths = (oldPhotoCount ..< newPhotoCount).map{ elem in
                    IndexPath(row: elem, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }completion: { _ in }
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath){
        let imageURL = photos[indexPath.row].thumbImageURL
        guard let url = URL(string: imageURL)
        else { return }
        
        let placeHolder = UIImage(resource: .stub)
        
        cell.imageCell.kf.indicatorType = .activity
        cell.imageCell.kf.setImage(
            with: url,
            placeholder: placeHolder,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]){[weak self] result in
                guard let self else { return }
                switch result{
                case .success(_):
                    DispatchQueue.main.async{
                        self.tableView.performBatchUpdates(nil)
                    }
                case .failure(let error):
                    print("[configCell]: не удалось загрузить картинку \(error.localizedDescription)")
                }
            }
        
        cell.delegate = self
        
        cell.likeButton.setImage(
            photos[indexPath.row].isLiked == true ?
            UIImage(named: ButtonIcons.LikeButtonOn.rawValue) :
                UIImage(named: ButtonIcons.LikeButtonOff.rawValue) ,
            for: .normal)
        if let date = photos[indexPath.row].createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = nil
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImagesListCell")
        
        guard let imageListCell = cell as? ImagesListCell else{
            return UITableViewCell()
        }
        
        configCell(for: imageListCell,with: indexPath)
        imageListCell.selectionStyle = .none
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1{
            service.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let singleImageView = SingleImageViewController()
        
        singleImageView.imageURLString = photos[indexPath.row].largeImageURL
        
        singleImageView.modalPresentationStyle = .fullScreen
        present(singleImageView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photos[indexPath.row].size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photos[indexPath.row].size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: ImagesListCellDelegate{
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        service.changeLike(photoId: photo.id, isLiked: photo.isLiked){[weak self] result in
            guard let self else { return }
            defer{
                UIBlockingProgressHUD.dismiss()
            }
            switch result{
            case .success():
                self.photos = self.service.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
            case .failure(let error):
                print("[changeLike]: не удалось установить/убрать лайк с фото \(error.localizedDescription)")
            }
            
        }
    }
    
    
}
