//
//  RestaurantService.swift
//  YelpyMari
//
//  Created by Mari Batilando on 1/12/22.
//

import Foundation

class RestaurantService {
  static let shared = RestaurantService()
    let apikey = "2nByXAp9wFypmgkmhOPg59pVMB6gqrkCr-OhesGay4yuRcMCgUjlkZ_MrIYLmsqCTcInk95-c-nGlnBty94wJotYS6wH-U11ITi3kMzEFsZW0p08482t1TKE7V8CYnYx"
    let session = URLSession(configuration: .default,
                             delegate: nil,
                             delegateQueue: .main)
  func fetchRestaurants(completion: @escaping (([RestaurantListItem]) -> Void)) {
    // Coordinates for San Francisco
    let lat = 37.773972
    let long = -122.431297
    let url = URL(string: "https://api.yelp.com/v3/transactions/delivery/search?latitude=\(lat)&longitude=\(long)")!
    var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
    // Insert API Key to request
    request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
    
    let session = URLSession(configuration: .default,
                             delegate: nil,
                             delegateQueue: .main)
    let task = session.dataTask(with: request) { (data, response, error) in
      // This will run when the network request returns
      if let error = error {
        print(error.localizedDescription)
      } else if let data = data {
        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let restaurantsRawData = dataDictionary["businesses"] as! [[String: Any]]
        var restaurants = [RestaurantListItem]()
        for rawData in restaurantsRawData {
            let restaurant = RestaurantListItem(id: rawData["id"] as! String,
                                        name: rawData["name"] as! String,
                                      type: (rawData["categories"] as! [[String: String]])[0]["title"]!,
                                      rating: (rawData["rating"] as! NSNumber).intValue,
                                      phoneNumber: rawData["display_phone"] as! String,
                                      imageURL: rawData["image_url"] as! String)
          restaurants.append(restaurant)
        }
        completion(restaurants)
      }
    }
      task.resume()
  }

    func fetchRestaurantDetail(id: String, completion: @escaping ((RestaurantDetail?) -> Void)) {

        let url = URL(string: "https://api.yelp.com/v3/businesses/\(id)")!
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        // Insert API Key to request
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // Converts raw json into a final usable Swift Object
                let decoder = JSONDecoder()
                let resaturantDetail = try? decoder.decode(RestaurantDetail.self, from: data)
                completion(resaturantDetail)
            }
        }
        task.resume()
    }
}
