//
//  FavouriteTableViewCell.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell, CellConfiguring {

    static var reuseID = String(describing: self)
    let previewImage = UIImageView()
    let nameAuthor = UILabel()
    let presenter = FavouriteTableViewCellPresenter()
    func configure<U>(value: U) where U: Hashable {
        setupCell()
        presenter.configure(value: value, self)
        self.selectionStyle = .none
    }
}

extension FavouriteTableViewCell {
    private func setupCell() {
        previewImage.contentMode = .scaleAspectFit
        previewImage.clipsToBounds = true
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        previewImage.backgroundColor = .systemFill
        previewImage.layer.cornerRadius = Constants.defaultCornerValue
        setNeedsLayout()
        self.contentView.addSubview(previewImage)
        self.contentView.addSubview(nameAuthor)
        nameAuthor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewImage.heightAnchor.constraint(equalToConstant: Constants.heightImageCell),
            previewImage.widthAnchor.constraint(equalToConstant: Constants.heightImageCell),
            previewImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                  constant: Constants.defaultValue),
            previewImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            nameAuthor.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                 constant: -Constants.defaultValue),
            nameAuthor.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
}
