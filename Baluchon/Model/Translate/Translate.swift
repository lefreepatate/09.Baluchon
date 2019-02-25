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
   
   private var task: URLSessionDataTask?
   private static let translateUrl =
      URL(string: "https://translation.googleapis.com/language/translate/v2?")!
   // MARK: -- FAKE DATATASK FOR TESTING
   private var session = URLSession.shared
   init(session: URLSession) {
      self.session = session
   }
   // MARK: -- GET GOOGLE TRANSLATE
   func getTranslate(with text: String, lang: String,
                     callBack: @escaping (Bool, String?) -> Void) {
      let request = createRequest(with: text, language: lang)
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
            guard let responseJSON = try? JSONDecoder().decode(Translations.self, from: data),
               let translate = responseJSON.data.translations![0].translatedText else {
                  callBack(false, nil)
                  return
            }
            callBack(true, translate)
         }
      }
      task?.resume()
   }
   // MARK: -- REQUEST PARAMETERS
   private func createRequest(with text: String, language: String) -> URLRequest {
      var source = ""
      var target = ""
      let key = "***"
      if language == "FR" {
         source = "fr"
         target = "en"
      } else if language == "EN" {
         source = "en"
         target = "fr"
      }
      let body = "key=\(key)&source=\(source)&target=\(target)&q=\(text)"
      var request = URLRequest(url: Translate.translateUrl)
      request.httpMethod = "POST"
      request.httpBody = body.data(using: .utf8)
      
      return request
   }
}
