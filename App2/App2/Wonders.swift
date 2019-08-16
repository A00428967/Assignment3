//
//  Wonders.swift
//  App2
//
//  Created by cda2019 on 2019-07-26.
//  Copyright © 2019 SMU. All rights reserved.
//

import Foundation

class Wonders {
    var name: String
    var wonderDescription: String?
    var userRating: Double
    var imageURL: String
    var coordinates: [Double]
    
    struct PropertyKey {
        static let name = "name"
        static let description = "description"
        static let userRating = "userRating"
        static let imageURL = "imageURL"
        static let coordinates = "coordinates"
    }
    
    init?(wonder: [String: Any]) {
        guard let properties = wonder["properties"] as? [String: Any], let geometry = wonder["geometry"] as? [String: Any] else { return nil }
        self.name = properties["name"] as? String ?? ""
        self.wonderDescription = properties["description"] as? String ?? ""
        self.userRating = properties["userRating"] as? Double ?? 0.0
        self.imageURL = properties["imageURL"] as? String ?? ""
        self.coordinates = geometry["coordinates"] as? [Double] ?? []
    }
    
    init(name: String, wonderDescription: String?, userRating: Double, imageURL: String, coordinates: [Double]) {
        self.name = name
        self.wonderDescription = wonderDescription
        self.userRating = userRating
        self.imageURL = imageURL
        self.coordinates = coordinates
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(wonderDescription, forKey: PropertyKey.description)
        aCoder.encode(userRating, forKey: PropertyKey.userRating)
        aCoder.encode(imageURL, forKey: PropertyKey.imageURL)
        aCoder.encode(coordinates, forKey: PropertyKey.coordinates)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String ?? ""
        let wonderDescription = aDecoder.decodeObject(forKey: PropertyKey.description) as? String
        let userRating = aDecoder.decodeObject(forKey: PropertyKey.userRating) as? Double ?? 0.0
        let imageURL = aDecoder.decodeObject(forKey: PropertyKey.imageURL) as? String ?? ""
        let coordinates = aDecoder.decodeObject(forKey: PropertyKey.coordinates) as? [Double] ?? [0.0, 0.0]
        
        self.init(name: name, wonderDescription: wonderDescription, userRating: userRating, imageURL: imageURL, coordinates: coordinates)
    }
    
}
