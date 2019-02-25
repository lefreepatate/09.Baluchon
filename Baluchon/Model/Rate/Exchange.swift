//
//  Exchange.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 21/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import Foundation

class Exchange {
   static var shared = Exchange()
   init() {}
   private static let key = "***"
   private static let rateURL =
      URL(string: "http://data.fixer.io/api/latest?access_key=\(key)&symbols=USD")!
   private var task: URLSessionDataTask?
   // MARK: -- FAKE DATATASK FOR TESTING
   private var session = URLSession.shared
   init(session: URLSession) {
      self.session = session
   }
   // MARK: -- GET FIXER API RATE
   func getRate(with amount: String, symbol: String, callBack: @escaping (Bool, Float?) -> Void) {
      let request = createRequest()
      task?.cancel()
      task = session.dataTask(with: request) { (data, response, error) in
         DispatchQueue.main.async {
            guard let data = data, error == nil else {
               callBack(false, nil)
               return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
               callBack(false, nil)
               return
            }
            guard let responseJSON = try? JSONDecoder().decode(RatesData.self, from: data),
               let rate = responseJSON.rates?.uSD else {
                  callBack(false, nil)
                  return
            }
            let usdRate = Float(rate)
            let dollars = Float(amount.replacingOccurrences(of: ",", with: "."))!
            var total: Float = 0
            if symbol == "$" {
               total = dollars/usdRate
            } else if symbol == "€" {
               total = dollars*usdRate
            }
            callBack(true, total)
         }
      }
      task?.resume()
   }
   private func createRequest() -> URLRequest {
      var request = URLRequest(url: Exchange.rateURL)
      request.httpMethod = "POST"
      return request
   }
}
