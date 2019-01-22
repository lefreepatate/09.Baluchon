//
//  Translate.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 21/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import Foundation

class Translate {
   static var shared = Translate()
   init() {}
   static let translateUrl =
      URL(string: "https://translation.googleapis.com/language/translate/v2?")!
   
   private var task: URLSessionDataTask?
   
   func getTranslate(with text: String, callBack: @escaping (Bool, String?) -> Void) {
      let request = createRequest(with: text)
      let session = URLSession(configuration: .default)
      
      task?.cancel()
      task = session.dataTask(with: request) { (data, response, error) in
         DispatchQueue.main.async {
            guard let data = data, error == nil else {
               callBack(false, nil)
               print("Text: \(text)")
               print("Error1")
               return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
               callBack(false, nil)
               print("Text: \(text)")
               print("Error2")
               return
            }
            guard let responseJSON = try? JSONDecoder().decode(Translations.self, from: data),
               let translate = responseJSON.translatedText else {
                  callBack(false, nil)
                  print("Text: \(text)")
                  print("Error3")
                  return
            }
            print("Text: \(text)")
            callBack(true, translate)
         }
      }
      task?.resume()
   }
   private func createRequest(with text: String) -> URLRequest {
      let key = "***"
      let source = "en"
      let target = "fr"
      let body = "key=\(key)&source=\(source)&target=\(target)&q=\(text)"
      var request = URLRequest(url: Translate.translateUrl)
      request.httpMethod = "POST"
      request.httpBody = body.data(using: .utf8)
      return request
   }
}
