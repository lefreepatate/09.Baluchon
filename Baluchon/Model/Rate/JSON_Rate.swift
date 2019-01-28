//
//  JSON_Rate.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 22/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import Foundation

struct RatesData: Decodable {
   let success : Bool?
   let timestamp : Int?
   let base : String?
   let date : String?
   let rates : Rates?
}

struct Rates: Decodable {
   let uSD: Double?
   enum CodingKeys: String, CodingKey {
      case uSD = "USD"
   }
}
