//
//  TabBarView.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//
import UIKit

private enum Screens: Int {
    case listVC
    case favoriteVC
}

class MainTabBarView: UITabBarController {
    let listButton = UIButton()
    let starButton = UIButton()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "background")
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        imageView.layer.cornerRadius = Constants.defaultValue * 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        setupTabBar()
    }
    
    private func setupButton(button: UIButton, image: UIImage, selector: Selector) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = Constants.buttonsSize * 0.5
        button.addTarget(self, action: selector, for: .touchUpInside)
        self.view.insertSubview(button, aboveSubview: self.tabBar)
        self.view.bringSubviewToFront(button)
    }
    
    private func makeUI() {
        self.view.addSubview(imageView)
        tabBar.isHidden = true
        setupButton(button: listButton,
                    image: #imageLiteral(resourceName: "list"),
                    selector: #selector(listButtonAction))
        setupButton(button: starButton,
                    image: #imageLiteral(resourceName: "star"),
                    selector: #selector(favoriteButtonAction))
        setupConstraints()
    }
    
    private func setupTabBar() {
        self.tabBar.isHidden = true
        DispatchQueue.main.async {
            let listVC = UINavigationController(rootViewController: ListViewController())
            let starVC = UINavigationController(rootViewController: FavoriteViewController())
            self.viewControllers = [listVC, starVC]
        }
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            listButton.heightAnchor.constraint(equalToConstant: Constants.buttonsSize),
            listButton.widthAnchor.constraint(equalToConstant: Constants.buttonsSize),
            listButton.leadingAnchor.constraint(equalTo: self.tabBar.leadingAnchor,
                                                constant: Constants.leadingAnchor),
            listButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -Constants.layoutValue),
            
            starButton.heightAnchor.constraint(equalToConstant: Constants.buttonsSize),
            starButton.widthAnchor.constraint(equalToConstant: Constants.buttonsSize),
            starButton.trailingAnchor.constraint(equalTo: self.tabBar.trailingAnchor,
                                                 constant: -Constants.leadingAnchor),
            starButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -Constants.layoutValue),
            imageView.leadingAnchor.constraint(equalTo: self.tabBar.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.tabBar.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.tabBar.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageViewHeight)
        ])
    }
    
    @objc
    private func favoriteButtonAction() {
        self.selectedIndex = Screens.favoriteVC.rawValue
    }
    
    @objc
    private func listButtonAction() {
        self.selectedIndex = Screens.listVC.rawValue
    }
}
