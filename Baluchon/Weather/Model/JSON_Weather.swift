//
//  JSON_Weather.swift
//  Baluchon
//
//  Created by Carlos Garcia-Muskat on 24/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

import Foundation
struct DataWeather : Decodable {
   let coord : Coord?
   let weather : [WeatherInfo]?
   let base : String?
   let main : Main?
   let visibility : Int?
   let wind : Wind?
   let clouds : Clouds?
   let dt : Int?
   let sys : Sys?
   let id : Int?
   let name : String?
   let cod : Int?
}

struct Coord : Decodable {
   let lon : Double?
   let lat : Double?
}

struct WeatherInfo : Decodable {
   let id : Int?
   let main : String?
   let description : String?
   let icon : String?
}

struct Main : Decodable {
   let temp : Double?
   let pressure : Int?
   let humidity : Int?
   let temp_min : Double?
   let temp_max : Double?
}

struct Wind : Decodable {
   let speed : Double?
}

struct Sys : Decodable {
   let type : Int?
   let id : Int?
   let message : Double?
   let country : String?
   let sunrise : Int?
   let sunset : Int?
}





struct Clouds : Decodable {
   let all : Int?
}
