//
//  FriendsUITests.swift
//  FriendsUITests
//
//  Created by Алёна Максимова on 04.04.2025.
//

import XCTest

final class FriendsUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testNavigationFlow() throws {
        let titleLabel = app.staticTexts["customTitleLabel"]
        XCTAssertTrue(titleLabel.waitForExistence(timeout: 5), "The custom title label 'Деньги' should exist")

        let avatarButton = app.buttons["avatarButton"]
        XCTAssertTrue(avatarButton.exists, "The avatar button should exist")

        avatarButton.tap()

        let backButton = app.navigationBars.buttons["Назад"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 5), "The back button should appear after navigation")

        backButton.tap()

        XCTAssertTrue(titleLabel.waitForExistence(timeout: 5),
                      "The custom title label 'Деньги' should reappear after returning")
    }
}
