//
//  RestaurantDetail.swift
//  YelpyMari
//
//  Created by Andros Slowley on 2/9/22.
//

import Foundation

struct RestaurantDetail: Codable {
  struct Category: Codable {
    let alias: String
    let title: String
  }
  
  // Step 1: Add coordinates property
  enum CodingKeys: String, CodingKey {
    case name
    case imageURL = "image_url"
    case isClosed = "is_closed"
    case priceRange = "price"
    case categories
    case photos
    case coordinates
  }
  
  let name: String
  let imageURL: String
  let isClosed: Bool
  let priceRange: String
  let categories: [Category]
  let photos: [String]
  let coordinates: [String: Double]
}
