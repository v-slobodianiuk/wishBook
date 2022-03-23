//
//  WishBookTests.swift
//  WishBookTests
//
//  Created by Vadym on 22.02.2021.
//

import XCTest
import Combine
@testable import WishBook

class ProfileServiceTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var profileService: ProfileServiceProtocol!
    private var profileModelTest: ProfileModel?
    private let testUserId: String = "gDeQhOKFrqRHliCBkcVbdORDjCK2"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        profileService = ProfileService()
        cancellables = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        profileService = nil
        cancellables = nil
        profileModelTest = nil
    }

    func testProfileModel() throws {
        let firstProfile = ProfileModel(id: "1", firstName: "Baz", lastName: "Bar")
        var secondProfile = ProfileModel(id: "1", firstName: "Baz", lastName: "Bar")
        XCTAssert(firstProfile == secondProfile)
        secondProfile.id = "2"
        XCTAssertFalse(firstProfile == secondProfile)
    }

    func testGetUserData() throws {
        let expectation = self.expectation(description: "GetProfileData")
        profileService.loadDataByUserId(testUserId)
            .sink { _ in

            } receiveValue: { [weak self] profileModel in
                self?.profileModelTest = profileModel
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 3.0)

        XCTAssertNotNil(profileModelTest)
        XCTAssertEqual(profileModelTest?.email, "test@test.com")
        XCTAssertEqual(profileModelTest?.firstName, "Test")
        XCTAssertEqual(profileModelTest?.lastName, "First")
    }

    func testUpdateDataBy() throws {
        var isUpdatedTest: Bool = false
        let expectation = self.expectation(description: "UpdateProfileDataByKey")
        profileService.updateDataBy(key: ProfileKey.firstName, value: "Test")
            .sink { isUpdated in
                isUpdatedTest = isUpdated
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 3.0)

        XCTAssert(isUpdatedTest, "Profile data updated")
    }

    func testUpdateData() throws {
        var isUpdatedTest: Bool = false

        let expectation = self.expectation(description: "UpdateProfileData")

        profileService.loadDataByUserId(testUserId)
            .flatMap { [weak self] (profileModel) -> AnyPublisher<Bool, ProfileServiceError> in
                var model = profileModel
                model.firstName = "Test"
                return self!.profileService.updateData(model)
            }
            .catch { (_: ProfileServiceError) -> AnyPublisher<Bool, Never> in
                XCTFail("testUpdateData error")
                return Empty().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
            .sink { isUpdated in
                isUpdatedTest = isUpdated
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 5.0)

        XCTAssert(isUpdatedTest, "Profile data updated")
    }

    func testProfileDataListener() throws {
        profileService.startProfileDataListener()
        XCTAssertTrue(profileService.profileDataListenerIsActive(), "Profile Data listener isn't active!")
        profileService.removeProfileDataListener()
        XCTAssertFalse(profileService.profileDataListenerIsActive(), "Profile Data listener is active!")
    }

    func testWishesListener() throws {
        profileService.startWishesListener()
        XCTAssertTrue(profileService.wishCounterListenerIsActive(), "Wishes listener isn't active!")
        profileService.removeWishesCountListener()
        XCTAssertFalse(profileService.wishCounterListenerIsActive(), "Wishes listener is active!")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension UserStorage {
    @UserDefaultsStorage<Bool>(key: "isLoggedInTest", defaultValue: false)
    static var isLoggedInTest
}
