//
//  SingleImageViewController.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 20.09.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var imageUrl: URL! {
        didSet {
            guard isViewLoaded else {return}
            setSingleImage()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        setSingleImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    @IBAction func tabBackButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func shareButtonDidPressed(_ sender: Any) {
        guard let image = imageUrl else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true)
    }
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    func setSingleImage() {
        UIBlockingProgressHUD.show()
        setImageFromUrl()
    }
    private func setImageFromUrl() {
        imageView.kf.setImage(with: imageUrl) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showImageError(imageUrl: imageUrl)
            }
        }
    }
    
    private func showImageError(imageUrl: URL) {
        let alert = UIAlertController(
                    title: "Что-то пошло не так",
                    message: "Не удалось поставить лайк",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.setImageFromUrl()
        }))
                self.present(alert, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}


