//
//  JSON+DataService.swift
//  Retail_Store_Puresoftware
//
//  Created by Dhirendra Kumar Verma on 28/06/24.
//

import Foundation

/// A service class for fetching products from a JSON file.
class DataService {
    
    /// Retrieves product data from the specified JSON file.
    /// - Parameters:
    ///  - fileName: The name of the JSON file.
    /// - Returns: An array of `ProductModel` objects if successful, otherwise `nil`.
    func getProducts(from fileName: String) -> [ProductModel]? {
        guard let filePath = Bundle(for: type(of: self)).path(forResource: fileName, ofType: Constants.fileType) else {
            debugPrint("Failed to locate \(fileName).json in bundle.")
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let decoder = JSONDecoder()
            let products = try decoder.decode([ProductModel].self, from: data)
            return products
        } catch {
            debugPrint("Failed to decode \(fileName).json: \(error)")
            return nil
        }
    }
}

