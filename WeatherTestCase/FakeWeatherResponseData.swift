//
//  FakeResponseData.swift
//  BaluchonTestsCaste
//
//  Created by Carlos Garcia-Muskat on 28/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import Foundation

class FakeWeatherResponseData {
   static var NewYorkCorrectData: Data? {
      let bundle = Bundle(for: FakeWeatherResponseData.self)
      let bundleUrl = bundle.url(forResource: "NewYorkWeather", withExtension: "json")
      return try! Data(contentsOf: bundleUrl!)
   }
   
   static var LocalCorrectData: Data? {
      let bundle = Bundle(for: FakeWeatherResponseData.self)
      let bundleUrl = bundle.url(forResource: "LocalWeather", withExtension: "json")
      return try! Data(contentsOf: bundleUrl!)
   }
   
   static let responseOK = HTTPURLResponse(url:
      URL(string: "http://api.openweathermap.org/data/2.5/forecast?")!,
                                    statusCode: 200, httpVersion: nil, headerFields: nil)
   static let responseKO = HTTPURLResponse(url:
      URL(string: "http://api.openweathermap.org/data/2.5/forecast?")!,
                                    statusCode: 500, httpVersion: nil, headerFields: nil)
   static let incorrectWeatherData = "erreur".data(using: .utf8)
   class WeatherError: Error {}
   static let error = WeatherError()
}

