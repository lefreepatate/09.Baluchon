//
//  JSON_Rate.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 22/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import Foundation

struct Rates: Codable {
   let uSD: Double?
   
   enum CodingKeys: String, CodingKey {
      
      case uSD = "USD"
   }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      uSD = try values.decodeIfPresent(Double.self, forKey: .uSD)
   }
   
}

struct Array: Codable {
   let success: Bool?
   let timestamp: Int?
   let base: String?
   let date: String?
   let rates: Rates?
   
   enum CodingKeys: String, CodingKey {
      
      case success = "success"
      case timestamp = "timestamp"
      case base = "base"
      case date = "date"
      case rates = "rates"
   }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      success = try values.decodeIfPresent(Bool.self, forKey: .success)
      timestamp = try values.decodeIfPresent(Int.self, forKey: .timestamp)
      base = try values.decodeIfPresent(String.self, forKey: .base)
      date = try values.decodeIfPresent(String.self, forKey: .date)
      rates = try values.decodeIfPresent(Rates.self, forKey: .rates)
   }
   
}
