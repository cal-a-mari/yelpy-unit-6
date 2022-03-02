//
//  RestaurantDetailViewController.swift
//  YelpyMari
//
//  Created by Andros Slowley on 2/8/22.
//

import AlamofireImage
import UIKit

final class RestaurantDetailViewController: UIViewController {
    
    /// Photo URLs to be use for fetching Restaurant images
    var photoURLs: [String] = []
    
    //MARK: IBOutlets

    @IBOutlet weak var mainImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var isOpenLabel: UILabel!

    @IBOutlet weak var priceRangeLabel: UILabel!

    @IBOutlet weak var imageCollectionView: UICollectionView! {
        didSet {
            imageCollectionView.dataSource = self
        }
    }

    @IBOutlet weak var categoryLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    /// Restaurant ID used to fetch detail content
    func configure(with restaurantID: String) {

        RestaurantService.shared.fetchRestaurantDetail(id: restaurantID) { [weak self] restaurant in
            guard let self = self, let restaurant = restaurant else {
                return
            }
            DispatchQueue.main.async {
                self.mainImageView.af.setImage(withURL: URL(string: restaurant.imageURL)!)
                self.nameLabel.text = restaurant.name
                let isOpenText = restaurant.isClosed ? "Closed" : "Open"
                self.isOpenLabel.text = "Currently: \(isOpenText)"
                self.priceRangeLabel.text = "Expense Rating: \(restaurant.priceRange)"
                if !restaurant.categories.isEmpty {
                    self.categoryLabel.text = "Food: \(restaurant.categories[0].title)"
                } else {
                    self.categoryLabel.isHidden = true
                }
                self.photoURLs = restaurant.photos
                self.imageCollectionView.reloadData()
            }
        }
    }
}

extension RestaurantDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionCell.identifier, for: indexPath) as? RestaurantCollectionCell else {
          return UICollectionViewCell()
        }
        cell.configure(with: photoURLs[indexPath.row])
        return cell
    }
}
