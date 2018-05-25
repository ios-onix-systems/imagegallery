//
//  ImageCollectionViewCell.swift
//  TestTask
//
//  Created by Serhiy on 5/22/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

enum UImageResult {
    case result(UIImage)
    case error(Error)
}

typealias UIImageCompletionType = (UImageResult) -> ()

protocol ImageListItemModelType {
    var address: String? { get }
    var weather: String { get }
    var image: UIImage? { get }
    
    func subscribeOnImageLoading(completion: @escaping UIImageCompletionType)
}

class ImageListItemModel: ImageListItemModelType {
    var address: String?
    var weather: String
    var image: UIImage?
    var imageUrl: String
    
    init(with model: Image) {
        self.address = model.address
        self.weather = model.weather ?? ""
        self.imageUrl = model.bigImagePath ?? ""
    }
    
    func subscribeOnImageLoading(completion: @escaping UIImageCompletionType) {
        if let image = image {
            completion(.result(image))
            return
        }
        
        ImageLoader.loadImage(imageUrl: imageUrl, completion: { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .result(let image):
                completion(.result(image))
            case .error(let error):
                completion(.error(error))
            }
        })
    }
    
}

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var bottomLabelContraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.containerView.layer.cornerRadius = 2
        self.containerView.layer.masksToBounds = false
        self.containerView.layer.shadowColor = UIColor.black.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 1, height: 3);
        self.containerView.layer.shadowOpacity = 1
    }

}

extension ImageCollectionViewCell {
    func configure(with model: ImageListItemModelType) {
        self.weatherLabel.text = model.weather
        
        if let address = model.address {
            self.addressLabel.text = address
        } else {
            self.addressLabel.isHidden = true
            bottomLabelContraint.isActive = false
        }
        
        model.subscribeOnImageLoading(completion: { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .result(let image):
                self.imageView.image = image
            case .error(let error):
                self.imageView.image = UIImage(named: "PlaceholderImage")
            }
        })
    }
}
