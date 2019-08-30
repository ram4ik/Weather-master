//
//  WeatherUITests.swift
//  WeatherUITests
//
//  Created by ramill on 04/08/2018.
//  Copyright © 2018 RI. All rights reserved.
//

import XCTest

class WeatherUITests: XCTestCase {
        
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
    
    func testUI() {

        let app = XCUIApplication()
        app.otherElements.containing(.image, identifier:"photo-1499479387933-4567e710809c").element.tap()

        let eGTallinnEstoniaTextField = app.textFields["e.g. Tallinn, Estonia"]
        eGTallinnEstoniaTextField.typeText("London")
        eGTallinnEstoniaTextField.tap()
        let getWeatherInfoButton = app.buttons["Get weather info"]
        getWeatherInfoButton.tap()

    }

    func testParis() {
        let app = XCUIApplication()
        app.otherElements.containing(.image, identifier:"photo-1499479387933-4567e710809c").element.tap()

        let eGTallinnEstoniaTextField = app.textFields["e.g. Tallinn, Estonia"]
        eGTallinnEstoniaTextField.typeText("Paris")
        eGTallinnEstoniaTextField.tap()
        let getWeatherInfoButton = app.buttons["Get weather info"]
        getWeatherInfoButton.tap()
    }
    
}
