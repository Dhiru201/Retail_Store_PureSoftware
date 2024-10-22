//
//  Cart_Screen_UI_Test.swift
//  Retail_Store_PuresoftwareUITests
//
//  Created by Dhirendra Kumar Verma on 29/06/24.
//

import Foundation
import XCTest
import Retail_Store_Puresoftware

class CartScreenTest: XCTestCase {
    var app: XCUIApplication!
    var cartScreen: CartScreen!
    var viewModel: CartViewModel!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        // open cart screen
        let cartButton = app.buttons["CartButton"]
        // Tap the cart button
        cartButton.tap()
        // Inject the service
        cartScreen = CartScreen(app: app)
        viewModel = CartViewModel()
        viewModel.fetchCartItems {}
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testTableIsLoadedWithData() {
        // Wait for the table to load
        let table = cartScreen.tableView
        XCTAssertTrue(table.waitForExistence(timeout: 5), "The product table view did not appear in time")
        
        // Check the number of cells (assuming there's at least 1 cell)
        XCTAssertGreaterThan(table.cells.count, 0, "The product table view is empty")
    }
    
    func testNavigationToDetailScreen() {
        let table = cartScreen.tableView
        XCTAssertTrue(table.waitForExistence(timeout: 5), "The product table view did not appear in time")
        
        // Tap the first cell
        table.cells.element(boundBy: 0).tap()
        
        // Verify the detail screen
        let detailScreenTitle = app.navigationBars["Product Details"].staticTexts["Product Details"]
        XCTAssertTrue(detailScreenTitle.exists, "The detail screen did not appear")
    }
    
    func testTableCellContainsCorrectData() {
        let tableView = cartScreen.tableView
        
        // Wait for the table view to appear
        XCTAssertTrue(tableView.waitForExistence(timeout: 5), "Table view not found")
        guard viewModel.numberOfRowsInSection() > 0 else { return }
        // Access the cell at a specific index path
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cells.element(boundBy: indexPath.row)
        let firstCellData = viewModel.dataForCell(indexPath)
        // Access the cell's label or other elements to verify its content
        let nameLabel = cell.staticTexts[firstCellData.name]
        let priceLabel = cell.staticTexts[String(format: "$ %.2f", firstCellData.price)]
        
        // Check if the cell contains the correct data
        XCTAssertEqual(nameLabel.label, firstCellData.name, "Cell does not contain the expected name")
        XCTAssertEqual(priceLabel.label, String(format: "$ %.2f", firstCellData.price), "Cell does not contain the expected price")
    }
    
    func testScreenTitle() {
        let title = cartScreen.screenTitle()
        // Define the expected title
        let expectedTitle = "Products Cart"
        // Check if the title matches the expected title
        XCTAssertEqual(title, expectedTitle, "Screen title doesn't match")
    }
    
    
}

