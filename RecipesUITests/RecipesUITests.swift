//
//  RecipesUITests.swift
//  RecipesUITests
//
//  Created by Mbusi Hlatshwayo on 3/9/25.
//

import XCTest

final class RecipesUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testRecipeListLoadsSuccessfully() throws {
        let navigationTitle = app.navigationBars["Recipes"]
        XCTAssertTrue(navigationTitle.exists, "Recipes navigation title should exist")
        
        let firstRecipe = app.cells.firstMatch
        XCTAssertTrue(firstRecipe.waitForExistence(timeout: 5), "Recipes should load within 5 seconds")
    }
    
    func testPullToRefresh() throws {
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.exists, "List should have at least one recipe")

        let startPoint = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let endPoint = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 1.5))
        startPoint.press(forDuration: 0.01, thenDragTo: endPoint)

        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "List should refresh and remain visible")
    }

    func testRecipeRowDisplaysCorrectInfo() throws {
        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "Recipes should be visible")

        let recipeName = firstCell.staticTexts.element(boundBy: 0)
        let recipeCuisine = firstCell.staticTexts.element(boundBy: 1)

        XCTAssertTrue(recipeName.exists, "Recipe name should be displayed")
        XCTAssertTrue(recipeCuisine.exists, "Recipe cuisine should be displayed")
    }
}
