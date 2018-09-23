//
//  SelectedCell.swift
//  iOS Club
//
//  Created by Yang Li on 2018/9/24.
//  Copyright © 2018 Yang LI. All rights reserved.
//

import UIKit

class SelectedCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setSelectedImage(selectedImage: UIImage) {
        imageView.image = selectedImage
        imageView.contentMode = .scaleAspectFit
    }
}
