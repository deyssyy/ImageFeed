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
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(){
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
