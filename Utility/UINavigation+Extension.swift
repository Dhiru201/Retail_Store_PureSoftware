//
//  UINavigation+Extension.swift
//  Retail_Store_Puresoftware
//
//  Created by Dhirendra Kumar Verma on 28/06/24.
//

import UIKit

extension UIViewController {
    // Sets up a cart button in the navigation bar.

    func setupCartButton() {
        let bagButton = BadgeButton()
        let count = ProductManager().getCartCount()
        bagButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        bagButton.tintColor = UIColor.darkGray
        bagButton.setImage(UIImage(named: Constants.cartIcon)?.withRenderingMode(.alwaysTemplate), for: .normal)
        bagButton.addTarget(self, action: #selector(cartDidClick), for: .touchUpInside)
        bagButton.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        if count > 0 {
            bagButton.badge = "\(count)"
        } else {
            bagButton.badge = ""
        }
        
        bagButton.accessibilityIdentifier = "CartButton"
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(customView: bagButton)
    }
    
    // Handles the tap event of the cart button.
    @objc private func cartDidClick() {
        let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        guard let cartVC = storyboard.instantiateViewController(identifier: "CartViewController") as? CartViewController else { return }
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
}
