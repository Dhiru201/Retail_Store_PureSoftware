//
//  CartTableCell.swift
//  Retail_Store_Puresoftware
//
//  Created by Dhirendra Kumar Verma on 28/06/24.
//

import UIKit

protocol CartCellDelegate: AnyObject {
    func didTapDeleteButton(in cell: CartTableCell)
}

class CartTableCell: UITableViewCell {
    weak var delegate: CartCellDelegate?
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset cell content
        productImageView.image = UIImage(named: Constants.noImageIcon)
        productNameLabel.text = .none
        productPriceLabel.text = .none
        productCategoryLabel.text = .none
    }
    
    /// Configures the cell with the specified product details.
    /// - Parameters:
    ///  - product: The `ProductModel` representing the product to be displayed.
    func configure(with product: ProductModel) {
        productNameLabel.text = product.name
        productPriceLabel.text = String(format: "$ %.2f", product.price)
        productCategoryLabel.text = product.category
        if let imageData = product.imageData {
            productImageView.image = UIImage(data: imageData)
        } else{
            productImageView.image = UIImage(named: Constants.noImageIcon)
        }
    }
    
    /// Handles the action when the delete button is tapped.
    /// - Parameters:
    ///  - sender: The button object that was tapped.
    @IBAction private func didTapDeleteProduct(_ sender: UIButton) {
        delegate?.didTapDeleteButton(in: self)
    }
}
