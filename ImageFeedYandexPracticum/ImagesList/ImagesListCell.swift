//
//  ImagesListCell.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 29.08.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonPressed(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    
    func setIsLiked(_ isLiked: Bool) {
        likeButton.setBackgroundImage(isLiked ? UIImage(named: "Active") : UIImage(named: "No_Active"), for: .normal)
    }
    
    func configCell(with photo: Photo) -> Bool{
        
        var createStatus = false
        
        likeButton.accessibilityIdentifier = "LikeButton"
        
        let imageUrl = photo.thumbImageURL
        
        let placeholder = UIImage(named: "image_cell_placeholder")
        
        cellImage.kf.indicatorType = .activity
        
        cellImage.kf.setImage(with: imageUrl, placeholder: placeholder) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                createStatus = true
            case .failure(_):
                cellImage.image = placeholder
                print("Error during image loading")
            }
            cellImage.kf.indicatorType = .none
        }
        
        guard let date = photo.createdAt else {
            print("Impossible to create a date")
            return createStatus
        }
        dateLabel.text = dateFormatter.string(from: date)
        
        let isLiked = photo.isLiked
        
        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No_Active")
        
        likeButton.setImage(likeImage, for: .normal)
        
        return createStatus
    }
}
