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
   private var session = URLSession.shared
   init(session: URLSession) {
      self.session = session
   }
   func getForecastWeather(with city: String, callBack: @escaping (Bool, [List]?) -> Void) {
      let forecastRequest = createRequest(city: city)
      task = session.dataTask(with: forecastRequest) { (data, response, error) in
         DispatchQueue.main.async {
            guard let data = data, error == nil else {
               callBack(false, nil)
               return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
               callBack(false, nil)
               return
            }
            guard let responseJSON = try? JSONDecoder().decode(WeatherData.self, from: data),
               let responseList = responseJSON.list  else {
                  callBack(false, nil)
                  return
            }
            let descr = responseJSON.list![0].weather[0].icon
            print(descr)
            callBack(true, responseList)
         }
      }
      task?.resume()
   }
   
  private func createRequest(city: String) -> URLRequest {
      let key = "***"
      let url = String(format:
         "http://api.openweathermap.org/data/2.5/forecast?APPID=\(key)&q=\(city)&units=metric&lang=fr")
      let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
      let weatherURL = URL(string: urlString)!
      var request = URLRequest(url: weatherURL)
      request.httpMethod = "POST"
      
      return request as URLRequest
   }
}
