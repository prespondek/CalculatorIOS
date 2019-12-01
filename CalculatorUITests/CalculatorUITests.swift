//
//  CalculatorUITests.swift
//  CalculatorUITests
//
//  Created by Peter Respondek on 26/11/19.
//  Copyright © 2019 Peter Respondek. All rights reserved.
//

import XCTest

class CalculatorUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func primeTests(app: XCUIApplication, test: @escaping ()->()) {
        app.launchArguments.append("--testing")
        app.launch()
        
        let exists = NSPredicate(format: "exists == true")
        let query = app.buttons["C"]
        expectation( for: exists, evaluatedWith: query,handler: nil )
        waitForExpectations(timeout: 3, handler: {error in
            test()
        })
    }
    
    func truncString(_ str: String, _ num: Int) -> String {
        return String(str[str.startIndex...str.index(str.startIndex, offsetBy: num)])
    }

    func testButtons() {
        let app = XCUIApplication()
        // UI tests must launch the application that they test.
        primeTests(app: app, test: {
            app.buttons["0"].tap()
            app.buttons["0"].tap()
            XCTAssertEqual(app.textFields["Output"].value as! String, "0")
            app.buttons["."].tap()
            app.buttons["1"].tap()
            XCTAssertEqual(app.textFields["Output"].value as! String, "0.1")
            app.buttons["."].tap()
            app.buttons["0"].tap()
            XCTAssertEqual(app.textFields["Output"].value as! String, "0.10")
            app.buttons["C"].tap()
            XCTAssertEqual(app.textFields["Output"].value as! String, "0")
            app.buttons["1"].tap()
            app.buttons["+"].tap()
            app.buttons["2"].tap()
            app.buttons["="].tap()
            XCTAssertEqual(app.textFields["Output"].value as! String, "3")
            app.buttons["×"].tap()
            app.buttons["3"].tap()
            app.buttons["."].tap()
            app.buttons["2"].tap()
            app.buttons["="].tap()
            XCTAssertEqual(app.textFields["Output"].value as! String, "9.6")
            app.buttons["−"].tap()
            app.buttons["4"].tap()
            app.buttons["="].tap()
            XCTAssertEqual(app.textFields["Output"].value as! String, "5.6")
            app.buttons["÷"].tap()
            app.buttons["5"].tap()
            app.buttons["="].tap()
            XCTAssertEqual(app.textFields["Output"].value as! String, "1.12")
            app.buttons["+"].tap()
            app.buttons["6"].tap()
            app.buttons["+"].tap()
            XCTAssertEqual(app.textFields["Output"].value as! String, "7.12")
            app.buttons["−"].tap()
            app.buttons["7"].tap()
            app.buttons["−"].tap()
            XCTAssertEqual(app.textFields["Output"].value as! String, "0.12")
            app.buttons["×"].tap()
            app.buttons["8"].tap()
            app.buttons["÷"].tap()
            XCTAssertEqual(app.textFields["Output"].value as! String, "-48.88")
            app.buttons["9"].tap()
            app.buttons["÷"].tap()
            XCTAssertEqual(self.truncString(app.textFields["Output"].value as! String, 5), "8.9777")
            app.buttons["0"].tap()
            app.buttons["="].tap()
            XCTAssertEqual(app.textFields["Output"].value as! String, "Not a Number")

        })
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
