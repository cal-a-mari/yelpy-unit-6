//
//  RestaurantDetailViewController.swift
//  YelpyMari
//
//  Created by Andros Slowley on 2/8/22.
//

import AlamofireImage
import UIKit
import MapKit

final class RestaurantDetailViewController: UIViewController {
  /// Photo URLs to be use for fetching Restaurant images
  var photoURLs: [String] = []
  
  // MARK: IBOutlets
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
  @IBOutlet weak var mapView: MKMapView!
  
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
        // Step 2: Create map view and set region of restaurant
        let coordinate =
        CLLocationCoordinate2D(latitude: restaurant.coordinates["latitude"] ?? 0.0,
                               longitude: restaurant.coordinates["longitude"] ?? 0.0)
        let restaurantRegion = MKCoordinateRegion(center: coordinate,
                                                  span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                         longitudeDelta: 0.01))
        self.mapView.setRegion(restaurantRegion, animated: true)
        // Step 3: Drop an annotation/pin on the map based on restaurant coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = restaurant.name
        self.mapView.addAnnotation(annotation)
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

extension RestaurantDetailViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    // Step 4: Create a custom view for the restaurant annotation
    let annotationView = MKPinAnnotationView(annotation: annotation,
                                             reuseIdentifier: "AnnotationViewReuseIdentifier")
    annotationView.canShowCallout = true
    let annotationViewButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
    annotationViewButton.setImage(UIImage(named: "camera"), for: .normal)
    annotationView.leftCalloutAccessoryView = annotationViewButton
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    // Step 5: Navigate to RestaurantImagePinViewController
    performSegue(withIdentifier: "RestaurantImageViewControllerSegue", sender: nil)
  }
  
  
}
