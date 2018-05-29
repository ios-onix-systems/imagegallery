//
//  ImageCollectionViewCell.swift
//  TestTask
//
//  Created by Serhiy on 5/22/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import UIKit


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
        
        model.loadImage(completion: { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .result(let image):
                self.imageView.image = image
            case .error( _):
                self.imageView.image = UIImage(named: "PlaceholderImage")
            }
        })
    }
}
