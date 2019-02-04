//
//  JSON_ForecastWeather.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 26/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import Foundation

struct WeatherData : Codable {
    let list : [List]!
}
struct List : Codable {
   let dt : Int
   let main : ForecastMain
   let weather : [ForecastWeather]
   let dt_txt : String?
}
struct ForecastMain : Codable {
   let temp : Double
   let temp_min : Double
   let temp_max : Double
}
struct ForecastWeather : Codable {
   let id : Int
   let main : String
   let description : String
   let icon : String
}
