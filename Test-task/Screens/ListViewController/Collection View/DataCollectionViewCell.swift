//
//  DataCollectionViewCell.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import UIKit

class CollectionViewDataCell: UICollectionViewCell, CellConfiguring {
    let previewImage = UIImageView()
    let nameOfAuthor = UILabel()
    let containerView = UIView()
    static var reuseID = String(describing: self)
    private var presenter: CollectionViewCellPresenter?
    
    func configure<U>(value: U) where U: Hashable {
        presenter?.configure(value: value, self)
    }
    
    private func initPresenter() {
        presenter = CollectionViewCellPresenter()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImage.image = nil
    }
    
    private func setupCell() {
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        nameOfAuthor.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(containerView)
        containerView.addSubview(previewImage)
        containerView.addSubview(nameOfAuthor)
        
        nameOfAuthor.font = UIFont.systemFont(ofSize: Constants.defaultCornerValue)
        nameOfAuthor.textColor = UIColor.black.withAlphaComponent(0.65)
        self.previewImage.layer.cornerRadius = Constants.defaultCornerValue
        self.previewImage.backgroundColor = .systemFill
        self.setNeedsLayout()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            previewImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            previewImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            previewImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            previewImage.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            
            nameOfAuthor.topAnchor.constraint(equalTo: previewImage.bottomAnchor,
                                              constant: Constants.defaultValue),
            nameOfAuthor.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initPresenter()
        setupCell()
        setupConstraints()
        self.previewImage.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
