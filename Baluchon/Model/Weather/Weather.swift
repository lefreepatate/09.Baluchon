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
   func getWeather(with city: String, type: String, callBack: @escaping (Bool, [Any]?) -> Void) {
      let request = createRequest(city: city, type: type)
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
            if type == "weather" {
               guard let responseJSON = try? JSONDecoder().decode(DataWeather.self, from: data),
                  let temp = responseJSON.main,
                  let cond = responseJSON.weather![0].description?.capitalized,
                  let icon = responseJSON.weather![0].icon,
                  let date = responseJSON.dt else {
                     callBack(false, nil)
                     return
               }
               let roundTemp = Int(round(temp.temp!))
               let roundMinTemp = Int(round(temp.temp_min!))
               let roundMaxTemp = Int(round(temp.temp_max!))
               let weather = [cond, icon, roundTemp, roundMinTemp, roundMaxTemp, date] as [Any]
               
               callBack(true, weather)
            } else if type == "forecast" {
               guard let responseJSON = try? JSONDecoder().decode(WeatherData.self, from: data),
                  let forecast = responseJSON.list else {
                     callBack(false, nil)
                     return
               }
               callBack(true, forecast)
            }
         }
      }
      task?.resume()
   }
   private func createRequest(city: String, type: String) -> URLRequest {
      let key = "***"
      let url = String(format:
         "http://api.openweathermap.org/data/2.5/\(type)?APPID=\(key)&q=\(city)&units=metric&lang=fr")
      let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
      let weatherURL = URL(string: urlString)!
      var request = URLRequest(url: weatherURL)
      request.httpMethod = "POST"
      
      return request as URLRequest
   }
}
