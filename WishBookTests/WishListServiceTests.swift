//
//  WishListServiceTests.swift
//  WishBookTests
//
//  Created by Vadym Slobodianiuk on 09.03.2022.
//

import XCTest
import Combine
@testable import WishBook

class WishListServiceTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var wishListService: WishListServiceProtocol!
    private let testUserId: String = "gDeQhOKFrqRHliCBkcVbdORDjCK2"
    private let loadLimit: Int = 3

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        wishListService = WishListService()
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        wishListService = nil
        cancellables = nil
    }

    func testWishListModel() throws {
        let mockDate = Date()
        let firstMockWish = WishListModel(createdTime: mockDate, title: "Baz")
        var secondMockWish = WishListModel(createdTime: mockDate, title: "Baz")
        XCTAssert(firstMockWish == secondMockWish)
        secondMockWish.title = "Bar"
        XCTAssertFalse(firstMockWish == secondMockWish)
    }

    func testLoadData() throws {
        var testWishList: [WishListModel]?
        let expectation = self.expectation(description: "Load wish list data")

        wishListService.loadData(userId: testUserId, limit: loadLimit)
            .catch { _ -> AnyPublisher<[WishListModel], Never> in
                XCTFail("testLoadData error")
                return Empty().eraseToAnyPublisher()
            }
            .sink { wishList in
                testWishList = wishList
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 3.0)

        XCTAssertNotNil(testWishList, "Wishes is nil")
    }

    func testLoadMore() throws {
        var testWishList: [WishListModel]?
        let expectation = self.expectation(description: "Load more wish list data")

        wishListService.loadData(userId: testUserId, limit: 1)
            .flatMap { [weak self] _ -> AnyPublisher<[WishListModel], Error> in
                guard let self = self else {
                    XCTFail("wishListService loadData error")
                    expectation.fulfill()
                    return Empty().eraseToAnyPublisher()
                }
                return self.wishListService.loadMore(userId: self.testUserId)
            }
            .catch { _ -> AnyPublisher<[WishListModel], Never> in
                XCTFail("wishListService loadMore error")
                return Empty().eraseToAnyPublisher()
            }
            .sink { wishList in
                testWishList = wishList
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 8.0)

        guard let wishes = testWishList else {
            XCTFail("wishes is nil")
            return
        }

        XCTAssert(!wishes.isEmpty, "No more wishes")
    }

    func testUpdateWish() throws {
        var wishTest: WishListModel?
        let expectation = self.expectation(description: "Update wish")
        wishListService.loadData(userId: testUserId, limit: loadLimit)
            .flatMap { [weak self] wishes -> AnyPublisher<WishListModel, Error> in
                guard let self = self, let wish = wishes.first else {
                    expectation.fulfill()
                    XCTFail("wishListService loadMore error")
                    return Empty().eraseToAnyPublisher()
                }
                var wishForModify = wish
                wishForModify.title = "Bar"
                return self.wishListService.updateData(wishForModify)
            }
            .catch { _ -> AnyPublisher<WishListModel, Never> in
                expectation.fulfill()
                XCTFail("wishListService updateData error")
                return Empty().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
            .sink { wish in
                wishTest = wish
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 5.0)
        XCTAssertEqual(wishTest?.title, "Bar")
    }

    func testAddWish() throws {
        var wishTest = WishListModel(title: "Baz")
        let expectation = self.expectation(description: "Add wish")

        wishListService.addData(wishTest)
            .catch { _ -> AnyPublisher<WishListModel, Never> in
                expectation.fulfill()
                XCTFail("wishListService addData error")
                return Empty().eraseToAnyPublisher()
            }
            .sink { wish in
                wishTest = wish
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 3.0)

        XCTAssertEqual(wishTest.userId, testUserId, "Wish userId data isn't equal userId")
    }

    func testDeleteItem() throws {
        var isRemovedTest = false
        let expectation = self.expectation(description: "DeleteWish")

        wishListService.loadData(userId: testUserId, limit: loadLimit)
            .flatMap { [weak self] wishes -> AnyPublisher<Bool, Error> in
                guard let self = self, let id = wishes.first?.id else {
                    expectation.fulfill()
                    XCTFail("wishListService loadData error")
                    return Empty().eraseToAnyPublisher()
                }
                return self.wishListService.delete(id: id)
            }
            .catch { (_: Error) -> AnyPublisher<Bool, Never> in
                expectation.fulfill()
                XCTFail("wishListService delete error")
                return Empty().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
            .sink { isRemoved in
                isRemovedTest = isRemoved
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 5.0)
        XCTAssert(isRemovedTest, "Delete wish item error")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
