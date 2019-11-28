//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Peter Respondek on 26/11/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOrderOfOperation() {
        var op = OperationExpression()
        op.set(10)
        op += 10
        op *= 5
        XCTAssertEqual(op.calculate(), 60, "Bad order of operation")
        op.clear()
        op.set(10)
        op += 10
        op += 0
        op *= 5
        XCTAssertEqual(op.calculate(), 20, "Bad order of operation")
        op.clear()
        op.set(30)
        op /= 5
        op *= 2
        op += 1
        XCTAssertEqual(op.calculate(), 13, "Bad order of operation")
    }
    
    func testMath() {
        var op = OperationExpression()
        op.set(2)
        op /= 0
        XCTAssert(op.calculate().isInfinite, "Not infinite")
        op.clear()
        op.set(0)
        op /= 0
        XCTAssert(op.calculate().isNaN, "Not nan")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
