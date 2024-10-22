//
//  ProductViewModel.swift
//  Retail_Store_Puresoftware
//
//  Created by Dhirendra Kumar Verma on 28/06/24.
//

import Foundation

public protocol ProductViewModelProtocol {
    var imageService: ImageDownloader { get }
    func fetchProducts(completion: @escaping () -> Void)
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func dataForCell(_ indexPath: IndexPath) -> ProductModel?
    func titleForHeaderInSection(_ section: Int) -> String
    
}

public class ProductViewModel: ProductViewModelProtocol {
    
    public let imageService = ImageDownloader()
    private let productService = DataService()
    private var productsByCategory: [String: [ProductModel]] = [:]
    
    public init() {}
    /// Returns the number of sections in the product list.
    /// - Returns: The number of sections.
    public func numberOfSections() -> Int {
        productsByCategory.keys.count
    }
    
    /// Returns the number of rows in the specified section.
    /// - Parameters:
    ///  - section: The section index.
    /// - Returns: The number of rows in the section.
    public func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 1:
            return productsByCategory["Electronics"]?.count ?? 0
        default:
            return productsByCategory["Furniture"]?.count ?? 0
        }
    }
    
    /// Returns the product data for the cell at the specified index path.
    /// - Parameters:
    ///  - indexPath: The index path of the cell.
    /// - Returns: The product data.
    public func dataForCell(_ indexPath: IndexPath) -> ProductModel? {
        switch indexPath.section {
        case 1:
            return productsByCategory["Electronics"]?[indexPath.item]
        default:
            return productsByCategory["Furniture"]?[indexPath.item]
        }
    }
    
    /// Returns the title for the header in the specified section.
    /// - Parameters:
    ///  - section:  The section index.
    /// - Returns: The title for the section header.
    public func titleForHeaderInSection(_ section: Int) -> String {
        return Array(productsByCategory.keys)[section]
    }
    
    /// Fetches products and performs a completion handler.
    /// - Parameters:
    ///  - completion: The completion handler.
    public func fetchProducts(completion: @escaping () -> Void) {
        if let products = productService.getProducts(from: Constants.jsonFileName) {
            // Categorize products
            productsByCategory = Dictionary(grouping: products, by: { $0.category })
        } else {
            self.productsByCategory = [:]
        }
        completion()
    }
}

