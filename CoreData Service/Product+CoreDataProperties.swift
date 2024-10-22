//
//  Product+CoreDataProperties.swift
//  Retail_Store_Puresoftware
//
//  Created by Dhirendra Kumar Verma on 28/06/24.
//

import Foundation
import CoreData


extension Product {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: Constants.entityName)
    }
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var category: String?
    @NSManaged public var price: Double
    @NSManaged public var productImageData: Data?
    
}

extension Product : Identifiable {
    
    /// Initializes a new `Product` object with the provided data model and managed object context.
    /// - Parameters:
    ///   - context: The `NSManagedObjectContext` to associate with the new object.
    ///   - model: The `ProductModel` containing the data for initializing the object.
    convenience init(context: NSManagedObjectContext, model: ProductModel) {
        self.init(context: context)
        self.id = model.id
        self.name = model.name
        self.price = model.price
        self.category = model.category
        self.productImageData = model.imageData
    }
    
    /// Converts the `Product` object to a `ProductModel
    func toModel() -> ProductModel {
        return ProductModel(id: self.id, name: self.name ?? "", price: self.price, productImage: nil, category: self.category ?? "", imageData: self.productImageData)
    }
    
    /// Fetches the image data from the provided image URL.
    /// - Parameters:
    ///   - imageName: The URL string of the image.
    private func fetchImageData(from imageName: String) -> Data? {
        if let url = URL(string: imageName), let data = try? Data(contentsOf: url) {
            return data
        }
        return nil
    }
}

