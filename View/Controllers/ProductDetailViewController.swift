//
//  ProductDetailViewController.swift
//  Retail_Store_Puresoftware
//
//  Created by Dhirendra Kumar Verma on 28/06/24.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    
    var product: ProductModel?
    /// The image downloader service for downloading product images.
    var imageService = ImageDownloader()
    /// The manager for performing product-related operations.
    var productManager = ProductManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Product Details"
        view.backgroundColor = .white
        addToCartButton.layer.cornerRadius = 8
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCartButton()
    }
    
    /// Configures the view with the specified product details.
    /// - Parameters:
    ///   - product: The `ProductModel` representing the product to be displayed.
    func configureView() {
        guard let product else { return }
        productNameLabel.text = product.name
        productPriceLabel.text = String(format: "$ %.2f", product.price)
        productCategoryLabel.text = product.category
        if let imageData = product.imageData {
            productImageView.image = UIImage(data: imageData)
        } else if let imageUrl = URL(string: product.productImage ?? "") {
            imageService.downloadImage(from: imageUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.productImageView.image = image
                    self?.product?.imageData = image?.jpegData(compressionQuality: 1)
                }
            }
        } else{
            productImageView.image = UIImage(named: Constants.noImageIcon)
        }
    }
    
    /// Handles the action when the 'Add to Cart' button is tapped.
    /// - Parameters:
    ///  - sender: The button object that was tapped.
    @IBAction func didTapAddToCart(_ sender: UIButton) {
        guard let product else { return }
        if productManager.addProduct(product) {
            showAlert(title: "Success", message: "Product added successfully!")
        } else {
            // for now it is handlling already avaliable product condition
            showAlert(title: "Warning", message: "Product is already in cart!")
        }
        
        setupCartButton()
    }
    
    /// Displays an alert with the specified title and message.
    /// - Parameters:
    ///  - title: The title of the alert.
    ///  - message: The message of the alert.
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
