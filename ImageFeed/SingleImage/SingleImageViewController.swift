import UIKit

final class SingleImageViewController: UIViewController{
    var image: UIImage?{
        didSet {
            guard isViewLoaded, let image else { return }
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }

    private let imageView = UIImageView()
    private let scrollView = UIScrollView()
    private let backButton = UIButton(type: .custom)
    private let shareButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    private func setupScrollView(){
        view.backgroundColor = .ypBlack
       
        imageView.contentMode = .scaleAspectFit
        
        backButton.setImage(UIImage(resource: .backwardButton), for: .normal)
        backButton.addTarget(self, action: #selector (didTapBackButton), for: .touchUpInside)
        shareButton.setImage(UIImage(resource: .sharingButton), for: .normal)
        shareButton.addTarget(self, action: #selector (didTapShareButton), for: .touchUpInside)
        shareButton.backgroundColor = .ypBlack
        shareButton.clipsToBounds = true
        shareButton.layer.cornerRadius = 25
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(backButton)
        view.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 48),
            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -51),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
        ])
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapShareButton(){
        guard let image = image else { return }
        let activityItems: [Any] = [image]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage){
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        if image.size != CGSize.zero {
            let imagesize = image.size
            let hScale = visibleRectSize.width / imagesize.width
            let vScale = visibleRectSize.height / imagesize.height
            let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
            scrollView.setZoomScale(scale, animated: true)
            scrollView.layoutIfNeeded()
            let newContentSize = scrollView.contentSize
            let x = (newContentSize.width - visibleRectSize.width) / 2
            let y = (newContentSize.height - visibleRectSize.height) / 2
            scrollView.setContentOffset(CGPoint(x: x, y: y), animated: true)
        }
    }
}

extension SingleImageViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = imageView.frame.size
        let xInset = max(0,(scrollViewSize.width - imageViewSize.width) / 2)
        let yInset = max(0,(scrollViewSize.height - imageViewSize.height) / 2)
        scrollView.contentInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
    }
}
