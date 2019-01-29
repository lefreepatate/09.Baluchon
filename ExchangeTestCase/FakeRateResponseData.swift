//
//  FakeResponseData.swift
//  BaluchonTestsCaste
//
//  Created by Carlos Garcia-Muskat on 28/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import Foundation

class FakeRateResponseData {
   static var rateCorrectData: Data? {
      let bundle = Bundle(for: FakeRateResponseData.self)
      let bundleUrl = bundle.url(forResource: "Fixer", withExtension: "json")
      return try! Data(contentsOf: bundleUrl!)
   }
   static let responseOK = HTTPURLResponse(url:
      URL(string: "http://data.fixer.io/api/latest?")!,
                                    statusCode: 200, httpVersion: nil, headerFields: nil)
   static let responseKO = HTTPURLResponse(url:
      URL(string: "http://data.fixer.io/api/latest?")!,
                                    statusCode: 500, httpVersion: nil, headerFields: nil)
   static let incorrectRateData = "erreur".data(using: .utf8)
   class RateError: Error {}
   static let error = RateError()
}

