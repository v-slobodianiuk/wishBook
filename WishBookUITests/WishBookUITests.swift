//
//  WishBookUITests.swift
//  WishBookUITests
//
//  Created by Vadym on 22.02.2021.
//

import XCTest

class WishBookUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginScreen() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        snapshot("01LoginScreen")
    }

    func testPasswordPrompt() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        app.secureTextFields["Password"].tap()
        sleep(1)
        let qKey = app/*@START_MENU_TOKEN@*/.keys["q"]/*[[".keyboards.keys[\"q\"]",".keys[\"q\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        qKey.tap()

        let wKey = app/*@START_MENU_TOKEN@*/.keys["w"]/*[[".keyboards.keys[\"w\"]",".keys[\"w\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        wKey.tap()

        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        snapshot("02PasswordPrompt")

        XCTAssertEqual(app.buttons["Weak password"].label, "Weak password")
        sleep(1)
        app.buttons["Weak password"].tap()
        snapshot("03PasswordPromptScreen")
        sleep(1)
        app.buttons["Close"].tap()
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
