//
//  cat.swift
//  compProj
//
//  Created by Kirill Kalashnikov on 5/19/20.
//  Copyright © 2020 Kirill Kalashnikov. All rights reserved.
//

import Foundation
import UIKit
//simplified struct of Welcome Element
class Cat{
    var name:String
    var description: String
    var url: String
    var life_span: String
    var intelligence: Int
    var energyLevel: Int
    var image: UIImage
    init(name:String, description: String, url: String,life_span: String ,intelligence: Int, energyLevel: Int) {
        self.name = name
        self.description = description
        self.url = url
        self.life_span = life_span
        self.intelligence = intelligence
        self.energyLevel = energyLevel
        self.image = UIImage.gifImageWithName("loading-text-gif-14")!
        self.downloadImage(from: URL(string: url)!)
        
    }
    func downloadImage(from url: URL) {
       // print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            //print(response?.suggestedFilename ?? url.lastPathComponent)
            //print("Download Finished")
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)!
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}


// MARK: - WelcomeElement
struct WelcomeElement: Codable {
    let breeds: [Breed]
    let id: String
    let url: String
    let width, height: Int
}

// MARK: - Breed
struct Breed: Codable {
    let weight: Weight
    let id, name: String
   
    let temperament, origin, countryCodes, countryCode: String
    let breedDescription, lifeSpan: String
    let indoor: Int
    let adaptability, affectionLevel, childFriendly: Int
    let dogFriendly, energyLevel, grooming, healthIssues: Int
    let intelligence, sheddingLevel, socialNeeds, strangerFriendly: Int
    let vocalisation, experimental, hairless, natural: Int
    let rare, rex, suppressedTail, shortLegs: Int
    let hypoallergenic: Int

    enum CodingKeys: String, CodingKey {
        case weight, id, name
   
        case temperament, origin
        case countryCodes = "country_codes"
        case countryCode = "country_code"
        case breedDescription = "description"
        case lifeSpan = "life_span"
        case indoor
        case adaptability
        case affectionLevel = "affection_level"
        case childFriendly = "child_friendly"
       
        case dogFriendly = "dog_friendly"
        case energyLevel = "energy_level"
        case grooming
        case healthIssues = "health_issues"
        case intelligence
        case sheddingLevel = "shedding_level"
        case socialNeeds = "social_needs"
        case strangerFriendly = "stranger_friendly"
        case vocalisation, experimental, hairless, natural, rare, rex
        case suppressedTail = "suppressed_tail"
        case shortLegs = "short_legs"
        case hypoallergenic
    }
}

// MARK: - Weight
struct Weight: Codable {
    let imperial, metric: String
}
