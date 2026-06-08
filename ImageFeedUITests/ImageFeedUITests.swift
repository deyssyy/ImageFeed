//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by nikita on 13.12.2025.
//

import XCTest
@MainActor
final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["testMode"]
        app.launch()
    }
    
    func testAuth() throws{
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        let cookieButton = webView.buttons["Accept all cookies"]
        if cookieButton.exists{
            cookieButton.tap()
        }
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("")
        
        let passwordTextfield = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextfield.waitForExistence(timeout: 5))
        
        passwordTextfield.tap()
        passwordTextfield.typeText("")
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws{
        let table = app.tables["ImageListTable"]
        XCTAssert(table.waitForExistence(timeout: 5))
        
        let cell = table.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        cell.swipeUp()
        
        let likeCell = table.children(matching: .cell).element(boundBy: 1)
        likeCell.buttons["LikeButtonOff"].tap()
        sleep(2)
        likeCell.buttons["LikeButtonOn"].tap()
        sleep(2)
        
        likeCell.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        
        image.pinch(withScale: 3.0, velocity: 1)
        sleep(1)
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(1)
        
        let backButton = app.buttons["ScrollViewBackButton"]
        backButton.tap()
        
        let newCell = table.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(newCell.waitForExistence(timeout: 5))
    }
    
    func testProfile() throws{
        let tabBar = app.tabBars["TabBar"]
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5))
        
        tabBar.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts[""].exists)
        XCTAssert(app.staticTexts[""].exists)
        
        let logoutButton = app.buttons["LogoutButton"]
        logoutButton.tap()
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
