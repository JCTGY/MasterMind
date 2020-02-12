//
//  MasterMindManagerTests.swift
//  MasterMindTests
//
//  Created by jeffrey chiang on 2/11/20.
//  Copyright © 2020 jeffrey chiang. All rights reserved.
//

import XCTest
@testable import MasterMind

class MasterMindManagerTests: XCTestCase {

  let masterMindManager = MasterMindManager()

  func testGetNumberFromColor() {
    XCTAssertEqual(masterMindManager.getNumberFromColor(UIColor.black), 0)
    XCTAssertEqual(masterMindManager.getNumberFromColor(UIColor.systemBlue), 1)
    XCTAssertEqual(masterMindManager.getNumberFromColor(UIColor.systemPurple), 2)
    XCTAssertEqual(masterMindManager.getNumberFromColor(UIColor.systemGreen), 3)
    XCTAssertEqual(masterMindManager.getNumberFromColor(UIColor.systemOrange), 4)
    XCTAssertEqual(masterMindManager.getNumberFromColor(UIColor.systemRed), 5)
    XCTAssertEqual(masterMindManager.getNumberFromColor(UIColor.systemTeal), 6)
    XCTAssertEqual(masterMindManager.getNumberFromColor(UIColor.systemIndigo), 7)
  }

  func testAssignKeyToCorrectKey() {
    masterMindManager.assignKeyToCorrectKey("")
    XCTAssertEqual(masterMindManager.correctKey.count, 0)
    masterMindManager.assignKeyToCorrectKey("5\n6\n7\n8\n")
    XCTAssertEqual(masterMindManager.correctKey.count, 4)
  }
}
