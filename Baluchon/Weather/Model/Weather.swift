//
//  File.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 24/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import Foundation

class Weather {
   static var shared = Weather()
   init() {}
   private var task: URLSessionDataTask?
   var city = ""
   
   func getWeather(with city: String, callBack: @escaping (Bool, String?) -> Void) {
      let request = createRequest(with: city)
      let session = URLSession(configuration: .default)
      task = session.dataTask(with: request) { (data, response, error) in
         DispatchQueue.main.async {
            guard let data = data, error == nil else {
               callBack(false, nil)
               print("ERROR 1")
               return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
               callBack(false, nil)
               print("ERROR 2")
               return
            }
            guard let responseJSON = try? JSONDecoder().decode(DataWeather.self, from: data),
               let temp = responseJSON.main?.temp, let cond = responseJSON.weather![0].description/*, let icon = responseJSON.weather![0].icon */else {
                  callBack(false, nil)
                  print("ERROR 3")
                  return
            }
            print(data)
            let roundTemp = Int(round(temp))
            let weather = "\(roundTemp)°C\n\(cond)"
            print(weather)
            
            callBack(true, weather)
         }
      }
      task?.resume()
   }
   private func createRequest(with city: String) -> URLRequest {
      let key = "***"
      let url = String(format: "http://api.openweathermap.org/data/2.5/weather?APPID=\(key)&q=\(city)&units=metric&lang=fr")
      let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
      let weatherURL = URL(string: urlString)!
      var request = URLRequest(url: weatherURL)
      request.httpMethod = "POST"
      
      return request as URLRequest
   }
}
