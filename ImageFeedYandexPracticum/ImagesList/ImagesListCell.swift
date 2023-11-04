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
}
