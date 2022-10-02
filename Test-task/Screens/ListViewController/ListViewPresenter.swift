//
//  ListViewPresenter.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import Foundation

enum Section: Int, CaseIterable {
    case list
}

protocol CellConfiguring: NSObjectProtocol {
    func configure<U: Hashable>(value: U)
    static var reuseID: String { get set }
}

class ListViewPresenter: NSObject {
    private var delegate: ListViewDelegate?
    var data = [LoadedData]()
    private var viewController: ListViewController?
    func setDelegate(_ delegate: ListViewDelegate) {
        self.delegate = delegate
    }

    func reloadData(_ viewController: ListViewController) {
        var snapShot = viewController.createSnapshot()
        snapShot.appendSections([.list])
        snapShot.appendItems(self.data, toSection: .list)
        viewController.dataSource?.apply(snapShot, animatingDifferences: true)
    }

    func setVC(_ viewController: ListViewController) {
        self.viewController = viewController
    }

    func fetchFirstLaunchData() {
        NetworkDataFetcher().getData(state: "\(FetchState.firstLaunch.rawValue)") { data in
            self.data = data ?? [LoadedData]()
            guard let viewController = self.viewController else { return }
            self.reloadData(viewController)
        }
    }

    func fetchQuerySearch(_ search: String) {
        NetworkDataFetcher().getData(state: "\(FetchState.search.rawValue)\(search)") { data in
            self.data = data ?? [LoadedData]()
            guard let viewController = self.viewController else { return }
            self.reloadData(viewController)
        }
    }

    func showDetailVC(indexPath: Int) {
        let value = data[indexPath]
        delegate?.showDetailVC(value)
    }
}
