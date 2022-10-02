//
//  DataCollectionViewCellPresenter.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import Foundation

class CollectionViewCellPresenter: NSObject {
    func configure<U>(value: U, _ cell: CollectionViewDataCell) where U: Hashable {
        guard let data: LoadedData = value as? LoadedData else {
            return
        }
        cell.previewImage.downloadImage(data.url ?? "")
        DispatchQueue.main.async {
            cell.nameOfAuthor.text = data.nameAuthor ?? ""
        }
    }
}
