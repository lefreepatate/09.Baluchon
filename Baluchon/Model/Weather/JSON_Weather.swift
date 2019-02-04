//
//  JSON_Weather.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 24/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//
import Foundation
struct DataWeather : Decodable {
   let weather : [WeatherInfo]?
   let main : Main?
   let visibility : Int?
   let dt : Int?
}
struct WeatherInfo : Decodable {
   let main : String?
   let description : String?
   let icon : String?
}
struct Main : Decodable {
   let temp : Double?
   let temp_min : Double?
   let temp_max : Double?
}
