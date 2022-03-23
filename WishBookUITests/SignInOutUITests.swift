//
//  SignInOutUITests.swift
//  WishBookUITests
//
//  Created by Vadym Slobodianiuk on 21.03.2022.
//

import XCTest

class SignInOutUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSignIn() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        app.textFields["Email"].tap()
        sleep(1)
        app.textFields["Email"].typeText("test@test.com")
        sleep(1)

        app.secureTextFields["Password"].tap()
        sleep(1)
        app.secureTextFields["Password"].typeText("AAAaaa1!")
        sleep(1)
        snapshot("04ContinueState")

        app.buttons["Continue"].tap()
        sleep(5)
        snapshot("05WishList")
    }

    func testSignOut() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        app.tabBars["Tab Bar"].buttons["Profile"].tap()
        snapshot("06Profile")
        app.navigationBars["Profile"].buttons["Sign Out"].tap()
        sleep(3)
        snapshot("07StartScreen")
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
