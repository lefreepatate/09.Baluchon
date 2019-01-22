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
   static let rateURL =
      URL(string: "http://data.fixer.io/api/latest")!
   
   private var task: URLSessionDataTask?
   
   func getRate(callBack: @escaping (Bool, Double?) -> Void) {
      let request = createRequest()
      let session = URLSession(configuration: .default)
      
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
            guard let responseJSON = try? JSONDecoder().decode(Rates.self, from: data),
               let rate = responseJSON.uSD else {
                  callBack(false, nil)
                  return
            }
            callBack(true, rate)
         }
      }
      task?.resume()
   }
   private func createRequest() -> URLRequest {
      let key = "***"
      let body = "?access_key=\(key)&symbols=USD"
      var request = URLRequest(url: Translate.translateUrl)
      request.httpMethod = "POST"
      request.httpBody = body.data(using: .utf8)
      return request
   }
}
