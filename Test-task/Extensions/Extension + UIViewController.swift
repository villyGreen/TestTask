//
//  Extension + UIViewController.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import UIKit

extension UIViewController {
    func configureCell<T: CellConfiguring, U: Hashable>(collectionView: UICollectionView,
                                                        cellType: T.Type,
                                                        model: U, indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseID,
                                                            for: indexPath) as? T else {
            fatalError("Unknown id cell")
        }
        cell.configure(value: model)
        return cell
    }
    
    func setupTabBar(_ tabBar: MainTabBarView, alphaValue: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            tabBar.imageView.alpha = alphaValue
            tabBar.listButton.alpha = alphaValue
            tabBar.starButton.alpha = alphaValue
        }
    }
    
    func showAlert(title: String, message: String, actionTitle: String, isCancelButton: Bool,
                   completion: @escaping ((Bool) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let style = isCancelButton ? UIAlertAction.Style.destructive : UIAlertAction.Style.default
        let alertAction = UIAlertAction(title: actionTitle, style: style) { _ in
            completion(true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        if isCancelButton {
            alert.addAction(cancelAction)
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
}
