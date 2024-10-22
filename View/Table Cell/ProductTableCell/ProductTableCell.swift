//
//  ProductTableCell.swift
//  Retail_Store_Puresoftware
//
//  Created by Dhirendra Kumar Verma on 28/06/24.
//

import UIKit

class ProductTableCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = UIImage(named: Constants.noImageIcon)
        productNameLabel.text = .none
        productPriceLabel.text = .none
    }
    
    /// Configures the cell with the specified product details.
    /// - Parameters:
    ///  - product: The `ProductModel` representing the product to be displayed.
    ///  - imageService: The image downloader service for downloading product images.
    func configure(with product: ProductModel, imageService: ImageDownloader) {
        productNameLabel.text = product.name
        productPriceLabel.text = String(format: "$ %.2f", product.price)
        if let imageUrl = URL(string: product.productImage ?? "") {
            imageService.downloadImage(from: imageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.productImageView.image = image
                }
            }
        } else {
            productImageView.image = UIImage(named: Constants.noImageIcon)
        }
    }
}
