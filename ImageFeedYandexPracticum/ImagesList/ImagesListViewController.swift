//
//  ViewController.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 26.08.2023.
//

import UIKit


protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol { get set }
    var tableView: UITableView! { get set }
    func setupTableView()
    func errorLikeAlert(error: Error)
}

final class ImagesListViewController: UIViewController {
    @IBOutlet internal var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListObserver: NSObjectProtocol?
    var presenter = ImagesListViewPresenter() as ImagesListViewPresenterProtocol
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    setupTableView()
        presenter.viewDidLoad()
        startObserveImagesListChanges()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopObserveImagesListChanges()
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.photosCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imagesListCell, with: indexPath)
        return imagesListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        presenter.calculateHeightForRow(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.chekIfNextPageNeeded(indexPath: indexPath)
    }
}

extension ImagesListViewController {
    // на будущее перенести функцию в ячейку
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        cell.delegate = self
        
        cell.likeButton.accessibilityIdentifier = "LikeButton"
        
        let imageUrl = presenter.returnPhoto(indexPath: indexPath).thumbImageURL
        
        let placeholder = UIImage(named: "image_cell_placeholder")
        
        cell.cellImage.kf.indicatorType = .activity
        
        cell.cellImage.kf.setImage(with: imageUrl, placeholder: placeholder) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            cell.cellImage.kf.indicatorType = .none
            
        }
        
        guard let date = presenter.returnPhoto(indexPath: indexPath).createdAt else { return }
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        let isLiked = presenter.returnPhoto(indexPath: indexPath).isLiked
        
        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No_Active")
        
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
}

extension ImagesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let imageUrl = presenter.returnPhoto(indexPath: indexPath).largeImageURL
            viewController.imageUrl = imageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController {
    func updateTableViewAnimated() {
        presenter.updateTableViewAnimated()
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return print("не удалось получить индекс ячейки") }
        presenter.imagesListCellDidTapLike(cell, indexPath: indexPath)
    }
    
    func errorLikeAlert(error: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось поставить лайк",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ImagesListViewController {
    private func startObserveImagesListChanges() {
        imagesListObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.presenter.updateTableViewAnimated()
        }
    //    presenter.fetchPhotos()
    }
    private func stopObserveImagesListChanges() {
        NotificationCenter.default.removeObserver(self, name: ImagesListService.didChangeNotification, object: nil)
    }
}

extension ImagesListViewController: ImagesListViewControllerProtocol {
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}
