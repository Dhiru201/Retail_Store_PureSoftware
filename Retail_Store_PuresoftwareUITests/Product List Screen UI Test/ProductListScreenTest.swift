//
//  ProductListScreenTest.swift
//  Retail_Store_PuresoftwareUITests
//
//  Created by Dhirendra Kumar Verma on 29/06/24.
//

import XCTest

import Foundation
import XCTest
import Retail_Store_Puresoftware

final class ProductListScreenTest: XCTestCase {
    var app: XCUIApplication!
    var productListScreen: ProductListScreen!
    var productViewModel: ProductViewModel!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        // Inject the service
        productListScreen = ProductListScreen(app: app)
        productViewModel = ProductViewModel()
        
        let expectation = expectation(description: "Fetch products")
        productViewModel.fetchProducts{
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil) // Adjust timeout as needed
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testIsTableLoaded() {
        // Wait for the table view to appear
        XCTAssertTrue(productListScreen.tableView.waitForExistence(timeout: 5), "Table view not found")

        // Check if the table view has cells
        XCTAssertTrue(productListScreen.tableView.cells.count > 0, "Table view has no cells, indicating no data loaded")
    }
    
    func testTableHeaderView() {
        // When: Wait for data to load
        XCTAssertTrue(productListScreen.waitForDataToLoad(), "Failed to load data in time")
        let sectionCount = productViewModel.numberOfSections()
        for section in 0..<sectionCount {
            let sectionTitle = productViewModel.titleForHeaderInSection(section)
            XCTAssertTrue(productListScreen.sectionHeaderTitle(sectionTitle), "sections in the table view does not match with the expected section.")
        }
    }
    
    func testTableCellCount() {
        // When: Wait for data to load
        XCTAssertTrue(productListScreen.waitForDataToLoad(), "Failed to load data in time")
        let sectionCount = productViewModel.numberOfSections()
        var totalCount = 0
        for section in 0..<sectionCount {
            let cellCount = productViewModel.numberOfRowsInSection(section: section)
            totalCount += cellCount
        }
        let expectedCellCount = productListScreen.numberOfRows()
        XCTAssertEqual(totalCount, expectedCellCount, "The total cell count does not match the expected count")
    }
    
    func testTableCellContainsCorrectData() {
        let tableView = productListScreen.tableView
           
        // Wait for the table view to appear
        XCTAssertTrue(tableView.waitForExistence(timeout: 5), "Table view not found")

        // Access the cell at a specific index path
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cells.element(boundBy: indexPath.row)
        let firstCellData = productViewModel.dataForCell(indexPath)
        // Access the cell's label or other elements to verify its content
        let nameLabel = cell.staticTexts["Chair"]
        let priceLabel = cell.staticTexts["$ 109.80"]
           
        // Check if the cell contains the correct data
        XCTAssertEqual(nameLabel.label, firstCellData?.name, "Cell does not contain the expected name")
        XCTAssertEqual(priceLabel.label, String(format: "$ %.2f", firstCellData?.price ?? 0.0), "Cell does not contain the expected price")
       }
    
    func testScreenTitle() {
        let title = productListScreen.screenTitle()
        // Define the expected title
        let expectedTitle = "Products List"
        // Check if the title matches the expected title
        XCTAssertEqual(title, expectedTitle, "Screen title doesn't match")
    }
    
    func testNavigationBarButtonForCart() {
        // Access the navigation bar button
        let cartButton = app.buttons["CartButton"]
        
        // Check if the button exists
        XCTAssertTrue(cartButton.exists, "Cart button not found in navigation bar")
        
        // Optionally, you can also check the button's label
        XCTAssertEqual(cartButton.label, "cartIcon", "Incorrect button image")
    }
    
    func testCartButtonAction() {
        // Access the cart button
        let cartButton = app.buttons["CartButton"]
        
        // Tap the cart button
        cartButton.tap()
        
        // Verify navigation to the cart screen or any unexpected UI change
        XCTAssertTrue(app.navigationBars["Products Cart"].exists, "Navigation to Cart screen failed")
    }
    
    
    func testTableCellTapOpensDetailPage() {
        let tableView = productListScreen.tableView

        // Tap on the first table cell
        let firstCell = tableView.cells.element(boundBy: 0)
        firstCell.tap()

        // Verify navigation to the detail page
        XCTAssertTrue(app.navigationBars["Product Details"].exists, "Navigation to detail page failed")
    }
}
