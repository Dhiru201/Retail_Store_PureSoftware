//
//  CartViewController.swift
//  Retail_Store_Puresoftware
//
//  Created by Dhirendra Kumar Verma on 28/06/24.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var cartProductTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalPriceValue: UILabel!
    private var viewModel: CartViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Products Cart"
        setupViewModel()
        prepareProductListView()
        fetchCartItems()
    }
    
    /// Fetches the items in the cart and updates the UI.
    private func fetchCartItems() {
        viewModel.fetchCartItems { [weak self] in
            self?.cartProductTableView.reloadData()
            if let totalPrice = self?.viewModel.totalPrice, totalPrice > 0 {
                self?.totalPriceValue.text = String(format: "$ %.2f", totalPrice)
                self?.totalPriceLabel.isHidden = false
                self?.totalPriceValue.isHidden = false
            } else {
                self?.totalPriceValue.text = "$ 0.0"
                self?.totalPriceLabel.isHidden = true
                self?.totalPriceValue.isHidden = true
            }
        }
    }
    
    /// Prepares the product list view by setting up table view data source and delegate.
    private func prepareProductListView() {
        cartProductTableView.dataSource = self
        cartProductTableView.delegate = self
        // Register the ProductTableCell
        let nib = UINib(nibName: "CartTableCell", bundle: nil)
        cartProductTableView.register(nib, forCellReuseIdentifier: "CartTableCell")
    }
    
    /// Sets up the view model for managing cart-related operations.
    private func setupViewModel() {
        self.viewModel = CartViewModel()
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(identifier: "ProductDetailViewController") as? ProductDetailViewController else { return }
        let product = viewModel.dataForCell(indexPath)
        detailVC.product = product
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension CartViewController: UITableViewDataSource, CartCellDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableCell", for: indexPath) as? CartTableCell else {
            return UITableViewCell()
        }
        let product = viewModel.dataForCell(indexPath)
        cell.delegate = self
        cell.configure(with: product)
        return cell
    }
    
    /// Delegate method called when the delete button in a cart cell is tapped.
    /// - Parameters:
    ///  - cell: The cart cell in which the delete button was tapped.
    func didTapDeleteButton(in cell: CartTableCell) {
        guard let indexPath = cartProductTableView.indexPath(for: cell) else { return }
        let product = viewModel.dataForCell(indexPath)
        if viewModel.removeCartItem(product) {
            fetchCartItems()
        }
    }
}
