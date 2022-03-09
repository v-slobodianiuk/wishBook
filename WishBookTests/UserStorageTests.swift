//
//  UserStorageTests.swift
//  WishBookTests
//
//  Created by Vadym Slobodianiuk on 09.03.2022.
//

import XCTest
@testable import WishBook

class UserStorageTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserStorage() throws {
        UserStorage.isLoggedInTest = true
        XCTAssert(UserStorage.isLoggedInTest)
        UserStorage.isLoggedInTest = false
        XCTAssertFalse(UserStorage.isLoggedInTest)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
