//
//  ProductManager.swift
//  Retail_Store_Puresoftware
//
//  Created by Dhirendra Kumar Verma on 28/06/24.
//

import Foundation

/// Manager class for performing product-related operations.
struct ProductManager {
    /// The product repository used for data access.
    private let productRepo = ProductRepository()
    
    /// Adds a new product.
    /// - Parameters:
    ///   - product: The `ProductModel` representing the product to be added.
    func addProduct(_ product: ProductModel) -> Bool {
        return productRepo.create(product: product)
    }
    
    /// Fetches all products.
    /// - Returns: An array of `ProductModel` objects representing all products, or nil if an error occurs.
    func fetchProducts() -> [ProductModel]? {
        return productRepo.getAll()
    }
    
    /// Deletes a product.
    /// - Parameters:
    ///   - product: The `ProductModel` representing the product to be deleted.
    ///   - Returns: A boolean value indicating whether the deletion was successful.
    func deleteProduct(product: ProductModel) -> Bool {
        return productRepo.delete(product: product)
    }
    
    func getCartCount() -> Int {
        return productRepo.productsCount()
    }
}
