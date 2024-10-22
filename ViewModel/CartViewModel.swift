//
//  CartViewModel.swift
//  Retail_Store_Puresoftware
//
//  Created by Dhirendra Kumar Verma on 28/06/24.
//

import Foundation

public protocol CartViewModelProtocol {
    var totalPrice: Double { get }
    func fetchCartItems(completion: @escaping () -> Void)
    func removeCartItem(_ product: ProductModel) -> Bool
    func numberOfRowsInSection() -> Int
    func dataForCell(_ indexPath: IndexPath) -> ProductModel
}

public class CartViewModel: CartViewModelProtocol {
    private var productManager = ProductManager()
    public var totalPrice: Double = 0.0
    private var cartItems = [ProductModel]()
    public init() {}
    /// Fetches cart items and performs a completion handler.
    /// - Parameters:
    ///  - completion: The completion handler.
    public func fetchCartItems(completion: @escaping () -> Void) {
        cartItems = productManager.fetchProducts() ?? []
        totalPrice = cartItems.reduce(0.0) { $0 + $1.price }
        completion()
    }
    
    /// Removes a cart item.
    /// - Parameters:
    ///  - product: The product model representing the item to be removed.
    /// - Returns: A boolean value indicating whether the removal was successful.
    public func removeCartItem(_ product: ProductModel) -> Bool {
        return productManager.deleteProduct(product: product)
    }
    
    /// Returns the number of rows in the cart.
    /// - Returns: The number of rows in the cart.
    public func numberOfRowsInSection() -> Int {
        return cartItems.count
    }
    
    /// Returns the cart item at the specified index path.
    /// - Parameters:
    ///  - indexPath: The index path of the cart item.
    /// - Returns: The cart item at the specified index path.
    public func dataForCell(_ indexPath: IndexPath) -> ProductModel {
        return cartItems[indexPath.item]
    }
}
