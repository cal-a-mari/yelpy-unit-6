//
//  RestaurantCollectionCell.swift
//  YelpyMari
//
//  Created by Andros Slowley on 2/9/22.
//

import AlamofireImage
import UIKit

class RestaurantCollectionCell: UICollectionViewCell {

    static let identifier = "RestaurantCollectionCell"

    @IBOutlet weak var imageView: UIImageView!

    func configure(with photoURL: String) {
        imageView.af.setImage(withURL: URL(string: photoURL)!)
    }

    override func prepareForReuse() {
        imageView.image = nil
    }
}
