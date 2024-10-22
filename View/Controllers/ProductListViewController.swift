//
//  ProductListViewController.swift
//  Retail_Store_Puresoftware
//
//  Created by Dhirendra Kumar Verma on 28/06/24.
//

import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var productListTableView: UITableView!
    private var viewModel: ProductViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Products List"
        view.backgroundColor = .white
        setupViewModel()
        prepareProductListView()
        /// Fetch products
        viewModel.fetchProducts { [weak self] in
            self?.productListTableView.reloadData()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCartButton()
    }
    
    /// Prepares the product list view by setting up table view data source and delegate.
    private func prepareProductListView() {
        productListTableView.dataSource = self
        productListTableView.delegate = self
        // Register the ProductTableCell
        let nib = UINib(nibName: "ProductTableCell", bundle: nil)
        productListTableView.register(nib, forCellReuseIdentifier: "ProductTableCell")
    }
    
    /// Sets up the view model for managing product-related operations.
    private func setupViewModel() {
        self.viewModel = ProductViewModel()
    }
}

extension ProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(identifier: "ProductDetailViewController") as? ProductDetailViewController,
              let product = viewModel.dataForCell(indexPath) else { return }
        detailVC.product = product
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(section)
    }
}

extension ProductListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableCell", for: indexPath) as? ProductTableCell,
              let product = viewModel.dataForCell(indexPath) else {
            return UITableViewCell()
        }
        cell.configure(with: product, imageService: viewModel.imageService)
        return cell
    }
}
