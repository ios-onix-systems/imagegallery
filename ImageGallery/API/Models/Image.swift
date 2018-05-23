//
//  Image.swift
//  TestTask
//
//  Created by Serhiy on 5/22/18.
//  Copyright © 2018 Serhiy. All rights reserved.
//

import Foundation

class APIParameters: Decodable {
    var longitude: Double
    var latitude: Double
    var weather: String
    var address: String?
    
    enum CodingKeys: String, CodingKey {
        case longitude, latitude, weather, address
    }
}

protocol ImageType {
    var id: Int { get }
    var description: String? { get }
    var hashtag: String? { get }
    var longitude: Double { get }
    var latitude: Double { get }
    var weather: String { get }
    var address: String? { get }
    var smallImagePath: String { get }
    var bigImagePath: String { get }
    var created: String { get }
    
}

class Image: ImageType, Decodable {
    var id: Int
    var description: String?
    var hashtag: String?
    var longitude: Double
    var latitude: Double
    var weather: String
    var address: String?
    var smallImagePath: String
    var bigImagePath: String
    var created: String
    
    
    enum RootKeys: String, CodingKey {
        case id, description, hashtag, smallImagePath, bigImagePath, created, parameters
    }
    
    enum ParametersKeys: String, CodingKey {
        case longitude, latitude, weather, address
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        description = try container.decode(String?.self, forKey: .description)
        hashtag = try container.decode(String?.self, forKey: .hashtag)
        smallImagePath = try container.decode(String.self, forKey: .smallImagePath)
        bigImagePath = try container.decode(String.self, forKey: .bigImagePath)
        created = try container.decode(String.self, forKey: .created)
    
        let parameters = try container.decode(APIParameters.self, forKey: .parameters)

        weather = parameters.weather
        longitude = parameters.longitude
        latitude = parameters.latitude
        address = parameters.address
    }
    
}
