//
//  ProductListScreen.swift
//  Retail_Store_PuresoftwareUITests
//
//  Created by Dhirendra Kumar Verma on 29/06/24.
//

import Foundation
import XCTest

class ProductListScreen {

    let app: XCUIApplication

    init(app: XCUIApplication) {
        self.app = app
    }

    var tableView: XCUIElement {
        return app.tables.element(boundBy: 0)
    }

    func waitForDataToLoad(timeout: TimeInterval = 10) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: tableView.cells.element(boundBy: 0))
        return XCTWaiter.wait(for: [expectation], timeout: timeout) == .completed
    }
    
    
    func sectionHeaderTitle(_ label: String) -> Bool {
        return tableView.staticTexts.matching(identifier: label).count == 1
    }

    func numberOfRows() -> Int {
        return tableView.cells.count
    }
    
    func screenTitle() -> String {
        // Access the navigation bar title
        let navigationBar = app.navigationBars.firstMatch
       return navigationBar.staticTexts.firstMatch.label
    }
}
