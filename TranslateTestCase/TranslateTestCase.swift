//
//  TranslateTestCase.swift
//  TranslateTestCase
//
//  Created by Carlos Garcia-Muskat on 29/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//
@testable import Baluchon
import XCTest

class TranslateTestCase: XCTestCase {
   var translate: Translate!
   var success: Bool!
   var translated : String?
   let expectation = XCTestExpectation(description: "Wait for queue change.")
   override func setUp() {
      super.setUp()
      translate = Translate()
      success = Bool()
   }
   func getTranslateSession(with sessionData: Foundation.Data?, response: URLResponse?, error: Error?,
                            toTranslate: String, lang: String,  xctBool: ()?, xctResponse: ()?) {
      // Given
      translate = Translate(session: URLSessionFake(data: sessionData, response: response, error: error))
      translate.getTranslate(with: toTranslate, lang: lang) { (success, rate) in
         // Then
         self.expectation.fulfill()
      }
      wait(for: [expectation], timeout: 0.05)
   }
   func testGetTranslateShouldPostFailedCallbackIfError(){
      getTranslateSession(with: nil, response: nil, error: FakeResponseData.error,
                          toTranslate: "", lang: "", xctBool: XCTAssertFalse(success),
                          xctResponse: XCTAssertNil(translated))
   }
   func testGetTranslateShouldPostFailedCallbackIfNoData(){
      getTranslateSession(with: nil, response: nil, error: nil,
                          toTranslate: "", lang: "", xctBool: XCTAssertFalse(success),
                          xctResponse: XCTAssertNil(translated))
   }
   func testGetTranslateShouldPostFailedCallbackIfIncorrectResponse(){
      getTranslateSession(with: FakeResponseData.incorrectTranslateData,
                          response: FakeResponseData.responseKO, error: nil,
                          toTranslate: "", lang: "", xctBool: XCTAssertFalse(success),
                          xctResponse: XCTAssertNil(translated))
   }
   func testGetTranslateShouldPostFailedCallbackIfIncorrectData(){
      getTranslateSession(with: FakeResponseData.incorrectTranslateData,
                          response: FakeResponseData.responseOK, error: nil,
                          toTranslate: "", lang: "", xctBool: XCTAssertFalse(success),
                          xctResponse: XCTAssertNil(translated))
   }
   func testGetTranslateShouldSuccessCallbackIfCorrectDataForEN(){
      getTranslateSession(with: FakeResponseData.translateCorrectData,
                          response: FakeResponseData.responseOK, error: nil,
                          toTranslate: "", lang: "", xctBool: nil, xctResponse: nil)
      translate.getTranslate(with: "House", lang: "EN") { (succes, translated) in
         // Then
         let text = "House"
         XCTAssertTrue(succes)
         XCTAssertNotNil(translated)
         XCTAssertEqual(text, translated!)
         self.expectation.fulfill()
      }
   }
   func testGetTranslateShouldSuccessCallbackIfCorrectDataForFR(){
      getTranslateSession(with: FakeResponseData.translateFRCorrectData,
                          response: FakeResponseData.responseOK, error: nil,
                          toTranslate: "", lang: "", xctBool: nil, xctResponse: nil)
      translate.getTranslate(with: "Maison", lang: "FR") { (succes, translated) in
         // Then
         let text = "Maison"
         XCTAssertTrue(succes)
         XCTAssertNotNil(translated)
         XCTAssertEqual(text, translated!)
         self.expectation.fulfill()
      }
   }
}
