//
//  ExchangeTestCase.swift
//  ExchangeTestCase
//
//  Created by Carlos Garcia-Muskat on 29/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

@testable import Baluchon
import XCTest

class ExchangeTestCase: XCTestCase {
   var exchange: Exchange!
   var success: Bool!
   var rate : Float!
   let expectation = XCTestExpectation(description: "Wait for queue change.")
   override func setUp() {
      super.setUp()
      exchange = Exchange()
      success = Bool()
   }
   func getRateSession(with sessionData: Foundation.Data?, response: URLResponse?, error: Error?,
                       amount: String, symbol: String,  xctBool: ()?, xctResponse: ()?) {
      // Given
      exchange = Exchange(session: URLSessionFake(data: sessionData, response: response, error: error))
      exchange.getRate(with: amount, symbol: symbol) { (success, rate) in
         // Then
         self.expectation.fulfill()
      }
      wait(for: [expectation], timeout: 0.05)
   }
   func testGetRateShouldPostFailedCallbackIfError(){
      getRateSession(with: nil, response: nil, error: FakeRateResponseData.error,
                     amount: "", symbol: "", xctBool: XCTAssertFalse(success),
                     xctResponse:  XCTAssertNil(rate))
   }
   func testGetRateShouldPostFailedCallbackIfNoData(){
      getRateSession(with: nil, response: nil, error: nil, amount: "", symbol: "", xctBool: XCTAssertFalse(success), xctResponse:  XCTAssertNil(rate))
   }
   func testGetTranslateShouldPostFailedCallbackIfIncorrectResponse(){
      getRateSession(with: FakeRateResponseData.incorrectRateData,
                     response: FakeRateResponseData.responseKO,
                     error: nil, amount: "", symbol: "", xctBool: XCTAssertFalse(success),
                     xctResponse:  XCTAssertNil(rate))
   }
   func testGetTranslateShouldPostFailedCallbackIfIncorrectData(){
      getRateSession(with: FakeRateResponseData.incorrectRateData,
                     response: FakeRateResponseData.responseOK, error: nil,
                     amount: "", symbol: "", xctBool: XCTAssertFalse(success),
                     xctResponse:  XCTAssertNil(rate))
   }
   func testGetTranslateShouldSuccessCallbackIfCorrectDataForEN(){
      getRateSession(with: FakeRateResponseData.rateCorrectData,
                     response: FakeRateResponseData.responseOK, error: nil, amount: "50",
                     symbol: "€", xctBool: nil, xctResponse: nil)
      exchange.getRate(with: "50", symbol: "$"){ (succes, rate) in
         // Then
         let rate = "1.144368"
         XCTAssertTrue(succes)
         XCTAssertNotNil(rate)
         XCTAssertEqual(rate, rate)
         self.expectation.fulfill()
      }
   }
}
