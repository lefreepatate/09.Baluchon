//
//  FakeResponseData.swift
//  BaluchonTestsCaste
//
//  Created by Carlos Garcia-Muskat on 28/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import Foundation

class FakeResponseData {
   static var translateCorrectData: Data? {
      let bundle = Bundle(for: FakeResponseData.self)
      let bundleUrl = bundle.url(forResource: "Translate", withExtension: "json")
      return try! Data(contentsOf: bundleUrl!)
   }
   static var translateFRCorrectData: Data? {
      let bundle = Bundle(for: FakeResponseData.self)
      let bundleUrl = bundle.url(forResource: "TranslateFR", withExtension: "json")
      return try! Data(contentsOf: bundleUrl!)
   }
   static let responseOK = HTTPURLResponse(url:
      URL(string: "https://translation.googleapis.com/language/translate/v2")!,
                                    statusCode: 200, httpVersion: nil, headerFields: nil)
   static let responseKO = HTTPURLResponse(url:
      URL(string: "https://translation.googleapis.com/language/translate/v2")!,
                                    statusCode: 500, httpVersion: nil, headerFields: nil)
   static let incorrectTranslateData = "erreur".data(using: .utf8)
   class TranslateError: Error {}
   static let error = TranslateError()
}

