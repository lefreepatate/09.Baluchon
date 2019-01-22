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
   private init() {}
   private static let translateUrl =
      URL(string: "https://translation.googleapis.com/language/translate/v2")!
   
   private var task: URLSessionDataTask?
   
   func getTranslate(with text: String, callBack: @escaping (Bool, Translated?) -> Void) {
      let request = createRequest(with: text)
      let share = URLSession.shared
      
      task?.cancel()
      task = share.dataTask(with: request) { (data, response, error) in
         DispatchQueue.main.async {
            guard let data = data, error == nil else {
               callBack(false, nil)
               return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
               callBack(false, nil)
               return
            }
            guard let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
               let text = responseJSON["translateURL"], let q = responseJSON["q"] else {
                  callBack(false, nil)
                  return
            }
            let dataString = String(data: data, encoding: .utf8)
            let translated = Translated(text:text, translated: q)
            print("dataString: \(String(describing: dataString)), tranlsated: \(translated)")
            callBack(true, translated)
         }
      }
      task?.resume()
   }
   private func createRequest(with text: String) -> URLRequest {
      let q = text
      let key = "***"
      let source = "fr"
      let target = "en"
      let body = "?key=\(key)&\(q)=langue&source=\(source)&target=\(target)&format=text"
      var request = URLRequest(url: Translate.translateUrl)
      request.httpMethod = "POST"
      request.httpBody = body.data(using: .utf8)
      return request
   }
}
