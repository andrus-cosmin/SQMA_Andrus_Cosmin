//
//  SQMAAssignmentsUITests.swift
//  SQMAAssignmentsUITests
//
//  Created by Cosmin Andrus on 14.01.2026.
//

import XCTest

final class SQMAAssignmentsUITests: XCTestCase {
    @MainActor
    func testInitialUIState() throws {
        let app = XCUIApplication()
        app.launch()

        // Title and subtitle exist
        XCTAssertTrue(app.staticTexts["Name Challenge"].exists)
        XCTAssertTrue(app.staticTexts["Type a name and see if it's cool!"].exists)

        // Text field with the label exists
        let nameTextField = app.textFields["Type a name"]
        XCTAssertTrue(nameTextField.exists)

        // Check button exists and should be disabled initially when no text
        let checkButton = app.buttons["Check Name"]
        XCTAssertTrue(checkButton.exists)
        XCTAssertFalse(checkButton.isEnabled)

        // Feedback text should not be visible at start (none of the messages)
        XCTAssertFalse(app.staticTexts["This is a cool name!"].exists)
        XCTAssertFalse(app.staticTexts["Not bad, but not cool name either."].exists)
        XCTAssertFalse(app.staticTexts["Keep trying, you're getting there!"].exists)
    }

    @MainActor
    func testCoolNameFlow() throws {
        let app = XCUIApplication()
        app.launch()

        let nameTextField = app.textFields["Type a name"]
        let checkButton = app.buttons["Check Name"]

        // Enter a name with more vowels than non-vowels
        nameTextField.tap()
        nameTextField.typeText("AaeB") // vowels=3, non-vowels=1

        // Button should now be enabled
        XCTAssertTrue(checkButton.isEnabled)

        checkButton.tap()

        // Expect cool feedback text to appear
        XCTAssertTrue(app.staticTexts["This is a cool name!"].waitForExistence(timeout: 1.0))
    }

    @MainActor
    func testAlmostCoolNameFlow() throws {
        let app = XCUIApplication()
        app.launch()

        let nameTextField = app.textFields["Type a name"]
        let checkButton = app.buttons["Check Name"]

        nameTextField.tap()
        nameTextField.typeText("ab") // vowels=1, non-vowels=1

        XCTAssertTrue(checkButton.isEnabled)

        checkButton.tap()

        XCTAssertTrue(app.staticTexts["Not bad, but not cool name either."].waitForExistence(timeout: 1.0))
    }

    @MainActor
    func testNotCoolNameFlow() throws {
        let app = XCUIApplication()
        app.launch()

        let nameTextField = app.textFields["Type a name"]
        let checkButton = app.buttons["Check Name"]

        nameTextField.tap()
        nameTextField.typeText("bbb") // vowels=0, non-vowels=3

        XCTAssertTrue(checkButton.isEnabled)

        checkButton.tap()

        XCTAssertTrue(app.staticTexts["Keep trying, you're getting there!"].waitForExistence(timeout: 1.0))
    }

    @MainActor
    func testChangingNameClearsFeedback() throws {
        let app = XCUIApplication()
        app.launch()

        let nameTextField = app.textFields["Type a name"]
        let checkButton = app.buttons["Check Name"]

        // Produce a feedback first
        nameTextField.tap()
        nameTextField.typeText("bbb")
        checkButton.tap()
        XCTAssertTrue(app.staticTexts["Keep trying, you're getting there!"].waitForExistence(timeout: 1.0))

        // Change name; feedback should disappear
        nameTextField.tap()
        nameTextField.doubleTap() // select word
        app.keys["delete"].tap() // clear selection on hardware keyboard-less devices may not work; also send delete
        nameTextField.typeText("a")

        // Expect previous feedback to no longer be visible
        // Allow a short delay for UI to update
        let feedback = app.staticTexts["Keep trying, you're getting there!"]
        sleep(1)
        XCTAssertFalse(feedback.exists)
    }
}
