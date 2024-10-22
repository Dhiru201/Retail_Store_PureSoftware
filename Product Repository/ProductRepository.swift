//
//  ProductRepository.swift
//  Retail_Store_Puresoftware
//
//  Created by Dhirendra Kumar Verma on 28/06/24.
//

import Foundation
import CoreData

protocol ProductRepositoryProtocol {
    func create(product: ProductModel) -> Bool
    func getAll() -> [ProductModel]?
    func delete(product: ProductModel)-> Bool
    func productsCount() -> Int
}

struct ProductRepository: ProductRepositoryProtocol {
    /// Creates a new product.
    /// - Parameters:
    ///   - product: The `ProductModel` to be created.
    func create(product: ProductModel) -> Bool{
        guard let productId = product.id, getProduct(byId: productId) == nil else {
            // product is already in cart we can add functionality to increase item count
            return false
        }
        let _ = Product(context: PersistentStorage.shared.context, model: product)
        // save context
        PersistentStorage.shared.saveContext()
        return true
    }
    
    /// Retrieves all products.
    /// - Returns: An array of `ProductModel` objects representing all products, or nil if an error occurs.
    func getAll() -> [ProductModel]? {
        let result = PersistentStorage.shared.fetchManagedObject(managedObject: Product.self)
        var products: [ProductModel] = []
        result?.forEach({ (product) in
            products.append(product.toModel())
        })
        return products
    }
    
    /// to get products Count
    func productsCount() -> Int {
        return getAll()?.count ?? 0
    }
    
    /// Deletes a product.
    /// - Parameters:
    ///   - product: The `ProductModel` representing the product to be deleted.
    /// - Returns: A boolean value indicating whether the deletion was successful.
    func delete(product: ProductModel) -> Bool{
        guard let productId = product.id, let product = getProduct(byId: productId) else { return false}
        PersistentStorage.shared.context.delete(product)
        PersistentStorage.shared.saveContext()
        return true
    }
    
    /// Retrieves a product by its unique identifier.
    /// - Parameters:
    ///   - id: The unique identifier of the product.
    /// - Returns: The `Product` object corresponding to the specified identifier, or nil if not found.
    private func getProduct(byId id: String) -> Product? {
        let fetchRequest = NSFetchRequest<Product>(entityName: Constants.entityName)
        let predicate = NSPredicate(format: Constants.idPredicate, id)
        
        fetchRequest.predicate = predicate
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first
            guard result != nil else { return nil}
            return result
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
}
