//
//  PlayerDemoUITests.swift
//  PlayerDemoUITests
//
//  Created by TimChen on 2017/6/1.
//  Copyright © 2017年 dogtim. All rights reserved.
//

import XCTest

class PlayerDemoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEnterPlayerPage() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCUIDevice.shared().orientation = .faceUp
        
        let app = XCUIApplication()
        
        app.buttons[Utility.get(key: "Enter Player Page")].tap()
        
        app.navigationBars[Utility.get(key: "Player")].buttons["Back"].tap()
        sleep(3)
    }
    
    func testZappingPlayerPage() {
        XCUIDevice.shared().orientation = .faceUp
        let app = XCUIApplication()

        app.buttons[Utility.get(key: "Enter Zapping Page")].tap()
        
        let element = app.scrollViews.children(matching: .other).element

        element.swipeLeft()
        sleep(2)
        element.swipeLeft()
        sleep(2)
        element.swipeLeft()
        sleep(2)
        element.swipeRight()
        sleep(2)
        element.swipeRight()
        sleep(2)
        element.swipeRight()
    }
    
}
