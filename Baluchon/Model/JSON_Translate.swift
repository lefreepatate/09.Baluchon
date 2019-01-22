//
//  Translated.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 21/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import Foundation

struct  Translations : Codable {
   let translatedText : String?
   
   enum CodingKeys: String, CodingKey {
      
      case translatedText = "translatedText"
   }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      translatedText = try values.decodeIfPresent(String.self, forKey: .translatedText)
}
}

 struct Data : Codable {
   let translations : [Translations]?
   
   enum CodingKeys: String, CodingKey {
      
      case translations = "translations"
   }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      translations = try values.decodeIfPresent([Translations].self, forKey: .translations)
   }
   
}
struct DataTranslate : Codable {
   let data : Data?
   
   enum CodingKeys: String, CodingKey {
      
      case data = "data"
   }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      data = try values.decodeIfPresent(Data.self, forKey: .data)
   }
   
}
