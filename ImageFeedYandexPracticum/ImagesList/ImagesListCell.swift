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
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
//    private func setImage(url: String) {
//        let url = URL(string: url)
//        cellImage.kf.setImage(with: url, placeholder: nil, options: nil) { <#Result<RetrieveImageResult, KingfisherError>#> in
//            <#code#>
//        }
//    }
}
