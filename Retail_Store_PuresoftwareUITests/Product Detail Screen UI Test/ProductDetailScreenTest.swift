//
//  ProductDetailScreenTest.swift
//  Retail_Store_PuresoftwareUITests
//
//  Created by Dhirendra Kumar Verma on 29/06/24.
//

import Foundation
import XCTest
import Retail_Store_Puresoftware

class ProductDetailScreenTest: XCTestCase {
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
        // Access the table view
        let tableView = productListScreen.tableView
        
        // Tap on the first table cell
        let firstCell = tableView.cells.element(boundBy: 0)
        firstCell.tap()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testDetailScreenElements() {
        let indexPath = IndexPath(row: 0, section: 0)
        guard let firstCellData = productViewModel.dataForCell(indexPath) else { return }
        
        // Access the elements on the detail screen
        let imageView = app.images.firstMatch
        let nameLabel = app.staticTexts[firstCellData.name]
        let priceLabel = app.staticTexts[ String(format: "$ %.2f", firstCellData.price)]
        let categoryLabel = app.staticTexts[firstCellData.category]
        let addToCartButton = app.buttons["ADD TO CART"]
        
        // Verify the existence of elements
        XCTAssertTrue(imageView.exists, "Image view does not exist")
        XCTAssertTrue(nameLabel.exists, "Name label does not exist")
        XCTAssertTrue(priceLabel.exists, "Price label does not exist")
        XCTAssertTrue(categoryLabel.exists, "Category label does not exist")
        XCTAssertTrue(addToCartButton.exists, "Add to cart button does not exist")
    }
    
    func testScreenTitle() {
        // Access the navigation bar title
        let navigationBar = app.navigationBars.element
        let title = navigationBar.staticTexts.firstMatch.label
        // Define the expected title
        let expectedTitle = "Product Details"
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
}
