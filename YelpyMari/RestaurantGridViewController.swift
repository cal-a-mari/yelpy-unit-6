//
//  RestaurantGridViewController.swift
//  YelpyMari
//
//  Created by Andros Slowley on 2/10/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class RestaurantGridViewController: UICollectionViewController {

    private var restaurants = [RestaurantListItem]() {
      didSet {
        collectionView.reloadData()
        collectionView.allowsMultipleSelection = false
      }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        RestaurantService.shared.fetchRestaurants { restaurants in
          self.restaurants = restaurants
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return restaurants.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionCell.identifier, for: indexPath) as? RestaurantCollectionCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: restaurants[indexPath.row].imageURL)
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toRestaurantDetail",
              let viewController = segue.destination as? RestaurantDetailViewController,
              let indexPath = collectionView.indexPathsForSelectedItems?.first else {
                  return
              }
        let selectedRestaurant = restaurants[indexPath.row]
        viewController.configure(with: selectedRestaurant.id)
    }
}
