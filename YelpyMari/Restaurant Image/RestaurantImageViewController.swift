//
//  RestaurantImageViewController.swift
//  YelpyMari
//
//  Created by Mari Batilando on 3/2/22.
//

import UIKit

protocol RestaurantImageViewControllerDelegate: AnyObject {
  func restaurantImageViewController(_ restaurantImageViewController: UIViewController,
                                     didSelectImage image: UIImage)
}

// Step 6: Define class with delegate protocol
class RestaurantImageViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var chooseImageButton: UIButton!
  
  weak var delegate: RestaurantImageViewControllerDelegate?
  private var selectedImage: UIImage?
  
  // Step 7: Show image picker controller
  @IBAction func didTapChooseImageButton(_ sender: UIButton) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera)
      ? .camera
      : .photoLibrary
    present(imagePicker, animated: true, completion: nil)
  }
}

extension RestaurantImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  // Step 8: Pass data back to restaurant detail view controller
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let chosenImage = info[.originalImage] as? UIImage else {
      print("Didn't choose an image")
      return
    }
    imageView.image = chosenImage
    delegate?.restaurantImageViewController(self, didSelectImage: chosenImage)
    dismiss(animated: true, completion: nil)
  }
}
