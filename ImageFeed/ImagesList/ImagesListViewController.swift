import UIKit
import Kingfisher

public protocol ImageListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? { get set }
    func updateTableViewAnimated(oldPhotoCount: Int, newPhotoCount: Int)
    func setLike(isLiked: Bool, for indexPath: IndexPath)
}

final class ImagesListViewController: UIViewController & ImageListViewControllerProtocol {
    
    private let tableView = UITableView()
    private var imageListServiceObserver: NSObjectProtocol?
    private var logoutObserver: NSObjectProtocol?
    var presenter: ImageListPresenterProtocol?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main){[weak self] _ in
                guard let self else { return }
                presenter?.updatePhotoCount()
            }
        logoutObserver = NotificationCenter.default.addObserver(
            forName: ProfileLogoutService.didLogoutNotification,
            object: nil,
            queue: .main){[weak self] _ in
                guard let self else { return }
                self.presenter?.resetStateForLogout()
                self.tableView.reloadData()
            }
        presenter?.viewDidLoad()
    }
    
    private func setupTableView(){
        tableView.accessibilityIdentifier = "ImageListTable"
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
    
    func updateTableViewAnimated(oldPhotoCount: Int, newPhotoCount: Int){
        tableView.performBatchUpdates {
            let indexPaths = (oldPhotoCount ..< newPhotoCount).map{ elem in
                IndexPath(row: elem, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }completion: { _ in }
    }
    
    func setLike(isLiked: Bool, for indexPath: IndexPath){
        if let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell{
            cell.setIsLiked(isLiked: isLiked)
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath){
        guard let photo = presenter?.getPhoto(at: indexPath) else { return }
        let imageURL = photo.thumbImageURL
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
            photo.isLiked == true ?
            UIImage(named: ButtonIcons.LikeButtonOn.rawValue) :
                UIImage(named: ButtonIcons.LikeButtonOff.rawValue) ,
            for: .normal)
        if let date = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = nil
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getPhotosCount() ?? 0
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
        if ProcessInfo.processInfo.arguments.contains("testMode") { return }
        if indexPath.row == (presenter?.getPhotosCount() ?? 0) - 1{
            presenter?.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let photo = presenter?.getPhoto(at: indexPath) else { return }
        
        let singleImageView = SingleImageViewController()
        
        singleImageView.imageURLString = photo.largeImageURL
        
        singleImageView.modalPresentationStyle = .fullScreen
        present(singleImageView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        guard let photo = presenter?.getPhoto(at: indexPath) else { return 0 }
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: ImagesListCellDelegate{
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.changeLike(at: indexPath)
    }
}
