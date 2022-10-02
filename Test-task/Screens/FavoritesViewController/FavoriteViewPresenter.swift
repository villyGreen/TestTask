//
//  FavoriteViewPresenter.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import Foundation

class FavoriteViewPresenter: NSObject {
    private var delegate: FavouriteViewDelegate?
    var data = [LoadedData]()
    func setDelegate(_ delegate: FavouriteViewDelegate) {
        self.delegate = delegate
    }

    func fetchData() {
        guard let fetchData = CoreDataService.standart.fetch() else {
            return
        }
        data = fetchData
        delegate?.getFetchedData()
    }
}
