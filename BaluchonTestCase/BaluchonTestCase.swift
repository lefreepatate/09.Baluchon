//
//  BaluchonTestCase2.swift
//  BaluchonTestCase2
//
//  Created by Carlos Garcia-Muskat on 28/01/2019.
//  Copyright © 2019 Carlos Garcia-Muskat. All rights reserved.
//

@testable import Baluchon
import XCTest

class BaluchonTestsCaste: XCTestCase {
   
   func testGetTranslateShouldPostFailedCallbackIfError(){
      // Given
      let translate = Translate(session:
         URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
      // When
      let expectation = XCTestExpectation(description: "Wait for queue change.")
      translate.getTranslate(with: "", language: "") { (succes, translated) in
         // Then
         XCTAssertFalse(succes)
         XCTAssertNil(translated)
         expectation.fulfill()
      }
      wait(for: [expectation], timeout: 0.05)
   }
   func testGetTranslateShouldPostFailedCallbackIfNoData(){
      // Given
      let translate = Translate(session:
         URLSessionFake(data: nil, response: nil, error: nil))
      // When
      let expectation = XCTestExpectation(description: "Wait for queue change.")
      translate.getTranslate(with: "", language: "") { (succes, translated) in
         // Then
         XCTAssertFalse(succes)
         XCTAssertNil(translated)
         expectation.fulfill()
      }
      wait(for: [expectation], timeout: 0.05)
   }
   func testGetTranslateShouldPostFailedCallbackIfIncorrectResponse(){
      // Given
      let translate = Translate(session:
         URLSessionFake(data: FakeResponseData.incorrectTranslateData,
                        response: FakeResponseData.responseKO, error: nil))
      // When
      let expectation = XCTestExpectation(description: "Wait for queue change.")
      translate.getTranslate(with: "", language: "") { (succes, translated) in
         // Then
         XCTAssertFalse(succes)
         XCTAssertNil(translated)
         expectation.fulfill()
      }
      wait(for: [expectation], timeout: 0.05)
   }
   func testGetTranslateShouldPostFailedCallbackIfIncorrectData(){
      // Given
      let translate = Translate(session:
         URLSessionFake(data: FakeResponseData.incorrectTranslateData,
                        response: FakeResponseData.responseOK, error: nil))
      // When
      let expectation = XCTestExpectation(description: "Wait for queue change.")
      translate.getTranslate(with: "", language: "") { (succes, translated) in
         // Then
         XCTAssertFalse(succes)
         XCTAssertNil(translated)
         expectation.fulfill()
      }
      wait(for: [expectation], timeout: 0.05)
   }
   func testGetTranslateShouldPostFailedCallbackIfNoErrorCorrectData(){
      // Given
      let translate = Translate(session:
         URLSessionFake(data: FakeResponseData.translateCorrectData,
                        response: FakeResponseData.responseOK, error: nil))
      // When
      let expectation = XCTestExpectation(description: "Wait for queue change.")
      translate.getTranslate(with: "House", language: "EN") { (succes, translated) in
         // Then
         let text = "House"
         XCTAssertTrue(succes)
         XCTAssertNotNil(translated)
         XCTAssertEqual(text, translated!)
         expectation.fulfill()
      }
      wait(for: [expectation], timeout: 0.05)
   }
}
