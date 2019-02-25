//
//  WeatherTestCase.swift
//  WeatherTestCase
//
//  Created by Carlos Garcia-Muskat on 29/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

@testable import Baluchon
import XCTest

class WeatherTestCase: XCTestCase {
   var mainWeather: Weather!
   var success: Bool!
   var weatherList: [Any]!
   
   let expectation = XCTestExpectation(description: "Wait for queue change.")
   override func setUp() {
      super.setUp()
      mainWeather = Weather()
      success = Bool()
   }
   func getWeatherResponse(with sessionData: Foundation.Data?, response: URLResponse?, error: Error?) {
      // Given
      mainWeather = Weather(session: URLSessionFake(data: sessionData, response: response, error: error))
      // Then
      self.expectation.fulfill()
   }
   func getWeatherSession(with city: String, type: String, xctBool: (), xctResponse: ()) {
      mainWeather.getWeather(with: city, type: type) { (success, weather) in
         // Then
         xctBool
         xctResponse
         self.expectation.fulfill()
      }
      wait(for: [expectation], timeout: 0.05)
   }
   func testGetWeatherShouldPostFailedCallbackIfError(){
      getWeatherResponse(with: nil, response: nil, error: FakeWeatherResponseData.error)
      getWeatherSession(with: "", type: "", xctBool: XCTAssertFalse(success),
                        xctResponse:  XCTAssertNil(weatherList))
   }
   func testGetWeatherShouldPostFailedCallbackIfNoData(){
      getWeatherResponse(with: nil, response: nil, error: nil)
      getWeatherSession(with: "", type: "",
                        xctBool: XCTAssertFalse(success!), xctResponse: XCTAssertNil(weatherList))
   }
   func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse(){
      getWeatherResponse(with: FakeWeatherResponseData.incorrectWeatherData,
                         response: FakeWeatherResponseData.responseKO, error: nil)
      getWeatherSession(with: "", type: "", xctBool: XCTAssertFalse(success!),
                        xctResponse: XCTAssertNil(weatherList))
      
   }
   func testGetWeatherShouldPostFailedCallbackIfIncorrectData(){
      getWeatherResponse(with: FakeWeatherResponseData.incorrectWeatherData,
                         response: FakeWeatherResponseData.responseOK, error: nil)
      getWeatherSession(with: "", type: "", xctBool: XCTAssertFalse(success!),
                        xctResponse: XCTAssertNil(weatherList))
   }
   func testGetNewYorkWeatherShouldPostSuccessCallbackIfCorrectData(){
      getWeatherResponse(with: FakeWeatherResponseData.NewYorkCorrectData,
                         response: FakeWeatherResponseData.responseOK, error: nil)
      mainWeather.getWeather(with: "New York", type: "weather") { (success, weatherList) in
         // Then
         let weatherDescription = "Ciel Dégagé"
         XCTAssertTrue(success)
         XCTAssertNotNil(weatherList)
         XCTAssertEqual(weatherDescription, weatherList![0] as! String)
      }
   }
   
   func testGetNewYorkForecastWeatherShouldPostSuccessCallbackIfCorrectData(){
      getWeatherResponse(with: FakeWeatherResponseData.NewYorkForecastCorrectData,
                         response: FakeWeatherResponseData.responseOK, error: nil)
      mainWeather.getWeather(with: "New York", type: "forecast") { (success, forecast) in
         if success, let forecast = forecast as! [List]? {
            // Then
            let temp = -11.07
            XCTAssertTrue(success)
            XCTAssertNotNil(forecast)
            XCTAssertEqual(temp, forecast[0].main.temp)
         }
      }
   }
   func testGeLocalWeatherShouldPostSuccessCallbackIfCorrectData(){
      getWeatherResponse(with: FakeWeatherResponseData.LocalCorrectData,
                         response: FakeWeatherResponseData.responseOK, error: nil)
      mainWeather.getWeather(with: "Lille", type: "weather") { (success, weather) in
         // Then
         let weatherDescription = "Légère Pluie"
         XCTAssertTrue(success)
         XCTAssertNotNil(weather)
         XCTAssertEqual(weatherDescription, weather![0] as! String)
      }
   }
   func testGetLocalForecastWeatherShouldPostSuccessCallbackIfCorrectData(){
      getWeatherResponse(with: FakeWeatherResponseData.LocalForecastCorrectData,
                         response: FakeWeatherResponseData.responseOK, error: nil)
      mainWeather.getWeather(with: "lille", type: "forecast") { (success, forecast) in
         if success, let forecast = forecast as! [List]? {
            let temp = 4.54
            XCTAssertTrue(success)
            XCTAssertNotNil(forecast)
            XCTAssertEqual(temp,forecast[0].main.temp)
         }
      }
   }
}
