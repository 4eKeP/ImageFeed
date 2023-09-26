//
//  SingleImageViewController.swift
//  ImageFeedYandexPracticum
//
//  Created by admin on 20.09.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else {return}
            imageView.image = image
        }
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    @IBAction func tabBackButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}

