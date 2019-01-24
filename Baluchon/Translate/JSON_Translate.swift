//
//  Translated.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 21/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import Foundation

struct Translations : Decodable {
   let data: Data
}
struct Data: Decodable {
   let translations: [TranslatedText]?
}
struct TranslatedText: Decodable {
   let translatedText : String?
}
