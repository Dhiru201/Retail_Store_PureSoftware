//
//  ProductModel.swift
//  Retail_Store_Puresoftware
//
//  Created by Dhirendra Kumar Verma on 28/06/24.
//

import Foundation

/// Data model representing product information.
public struct ProductModel: Codable {
    let id: String?
    let name: String
    let price: Double
    let productImage: String?
    let category: String
    var imageData: Data?
}

