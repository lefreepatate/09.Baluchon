//
//  WeatherTestCase.swift
//  WeatherTestCase
//
//  Created by Carlos Garcia-Muskat on 29/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//


import XCTest
@testable import Baluchon

class WeatherTestCase: XCTestCase {
   var weather: Weather!
   var success: Bool!
   var weatherList : [List]!
   let expectation = XCTestExpectation(description: "Wait for queue change.")
   override func setUp() {
      super.setUp()
      weather = Weather()
      success = Bool()
   }
   func getWeatherSession(with
      sessionData: Foundation.Data?, response: URLResponse?, error: Error?,
                                     city: String, xctBool: ()?, xctResponse: ()?) {
      // Given
      weather = Weather(session: URLSessionFake(data: sessionData, response: response, error: error))
      weather.getForecastWeather(with: city) { (success, weather) in
         // Then
         self.expectation.fulfill()
      }
      wait(for: [expectation], timeout: 0.05)
   }
   
   func testGetWeatherShouldPostFailedCallbackIfError(){
      getWeatherSession(with: nil, response: nil, error: FakeWeatherResponseData.error, city: "",
                        xctBool: XCTAssertFalse(success!), xctResponse: XCTAssertNil(weatherList))
      
   }
   func testGetWeatherShouldPostFailedCallbackIfNoData(){
      getWeatherSession(with: nil, response: nil, error: nil, city: "",
                        xctBool: XCTAssertFalse(success!), xctResponse: XCTAssertNil(weatherList))
   }
   func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse(){
      getWeatherSession(with: FakeWeatherResponseData.incorrectWeatherData,
                        response: FakeWeatherResponseData.responseKO,
                        error: nil, city: "", xctBool: XCTAssertFalse(success!),
                        xctResponse: XCTAssertNil(weatherList))
   }
   func testGetWeatherShouldPostFailedCallbackIfIncorrectData(){
      getWeatherSession(with: FakeWeatherResponseData.incorrectWeatherData,
                        response: FakeWeatherResponseData.responseOK,
                        error: nil, city: "",xctBool: XCTAssertFalse(success!),
                        xctResponse: XCTAssertNil(weatherList))
   }
   func testGetNewYorkWeatherShouldPostSuccessCallbackIfCorrectData(){
      getWeatherSession(with: FakeWeatherResponseData.NewYorkCorrectData, response: FakeWeatherResponseData.responseOK, error: nil, city: "", xctBool: nil, xctResponse: nil)
      weather.getForecastWeather(with: "New York") { (success, weather) in
         // Then
         let weatherDescription = "partiellement nuageux"
         XCTAssertTrue(success)
         XCTAssertNotNil(weather)
         XCTAssertEqual(weatherDescription, weather![0].weather[0].description)
         self.expectation.fulfill()
      }
   }
   func testGetLocalWeatherShouldPostSuccessCallbackIfCorrectData(){
      getWeatherSession(with: FakeWeatherResponseData.LocalCorrectData, response: FakeWeatherResponseData.responseOK, error: nil, city: "", xctBool: nil, xctResponse: nil)
      weather.getForecastWeather(with: "Lille") { (success, weather) in
         // Then
         let weatherDescription = "nuageux"
         XCTAssertTrue(success)
         XCTAssertNotNil(weather)
         XCTAssertEqual(weatherDescription, weather![0].weather[0].description)
         self.expectation.fulfill()
      }
   }
}
