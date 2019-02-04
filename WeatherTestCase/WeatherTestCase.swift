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
   var weather: Weather!
   var success: Bool!
   var weatherList : [Any]?
   
   let expectation = XCTestExpectation(description: "Wait for queue change.")
   override func setUp() {
      super.setUp()
      weather = Weather()
      success = Bool()
   }
   func getWeatherSession(with sessionData: Foundation.Data?, response: URLResponse?, error: Error?,
                          city: String, type: String, xctBool: ()?, xctResponse: ()?) {
      // Given
      weather = Weather(session: URLSessionFake(data: sessionData, response: response, error: error))
      weather.getWeather(with: city, type: "") { (success, weather) in
         // Then
         self.expectation.fulfill()
         self.wait(for: [self.expectation], timeout: 0.05)
      }
      
   }
   func testGetWeatherShouldPostFailedCallbackIfError(){
      getWeatherSession(with: nil, response: nil, error: FakeWeatherResponseData.error, city: "", type: "",
                        xctBool: XCTAssertFalse(success!), xctResponse: XCTAssertNil(weatherList))
      
   }
   func testGetWeatherShouldPostFailedCallbackIfNoData(){
      getWeatherSession(with: nil, response: nil, error: nil, city: "", type: "",
                        xctBool: XCTAssertFalse(success!), xctResponse: XCTAssertNil(weatherList))
   }
   func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse(){
      getWeatherSession(with: FakeWeatherResponseData.incorrectWeatherData,
                        response: FakeWeatherResponseData.responseKO,
                        error: nil, city: "", type: "", xctBool: XCTAssertFalse(success!),
                        xctResponse: XCTAssertNil(weatherList))
   }
   func testGetWeatherShouldPostFailedCallbackIfIncorrectData(){
      getWeatherSession(with: FakeWeatherResponseData.incorrectWeatherData,
                        response: FakeWeatherResponseData.responseOK,
                        error: nil, city: "", type: "", xctBool: XCTAssertFalse(success!),
                        xctResponse: XCTAssertNil(weatherList))
   }
   func testGetNewYorkWeatherShouldPostSuccessCallbackIfCorrectData(){
      getWeatherSession(with: FakeWeatherResponseData.NewYorkCorrectData,
                        response: FakeWeatherResponseData.responseOK, error: nil,
                        city: "New York", type: "weather", xctBool: nil, xctResponse: nil)
      weather.getWeather(with: "New York", type: "weather") { (success, weather) in
         // Then
         let weatherDescription = "ciel dégagé"
         XCTAssertTrue(success)
         XCTAssertNotNil(weather)
         XCTAssertEqual(weatherDescription,"\(weather![0])")
         self.expectation.fulfill()
      }
   }
   func testGetNewYorkForecastWeatherShouldPostSuccessCallbackIfCorrectData(){
      getWeatherSession(with: FakeWeatherResponseData.NewYorkForecastCorrectData,
                        response: FakeWeatherResponseData.responseOK, error: nil,
                        city: "", type: "", xctBool: nil, xctResponse: nil)
      weather.getWeather(with: "New York", type: "forecast") { (success, forecast) in
         if success, let forecast = forecast as! [List]? {
            // Then
            let temp = -11.07
            XCTAssertTrue(success)
            XCTAssertNotNil(forecast)
            XCTAssertEqual(temp, forecast[0].main.temp)
            self.expectation.fulfill()
         }
      }
   }
   func testGeLocalWeatherShouldPostSuccessCallbackIfCorrectData(){
      getWeatherSession(with: FakeWeatherResponseData.LocalCorrectData,
                        response: FakeWeatherResponseData.responseOK, error: nil,
                        city: "", type: "",  xctBool: nil, xctResponse: nil)
      weather.getWeather(with: "Lille", type: "weather") { (success, weather) in
         if success, let weather = weather {
            // Then
            let weatherDescription = "légère pluie"
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)
            XCTAssertEqual(weatherDescription,"\(weather[0])" )
            self.expectation.fulfill()
         }
      }
   }
   func testGetLocalForecastWeatherShouldPostSuccessCallbackIfCorrectData(){
      getWeatherSession(with: FakeWeatherResponseData.LocalForecastCorrectData,
                        response: FakeWeatherResponseData.responseOK, error: nil,
                        city: "", type: "", xctBool: nil, xctResponse: nil)
      weather.getWeather(with: "lille", type: "forecast") { (success, forecast) in
         if success, let forecast = forecast as! [List]? {
            let temp = 4.54
            XCTAssertTrue(success)
            XCTAssertNotNil(forecast)
            XCTAssertEqual(temp,forecast[0].main.temp)
            
            self.expectation.fulfill()
         }
      }
   }
}
