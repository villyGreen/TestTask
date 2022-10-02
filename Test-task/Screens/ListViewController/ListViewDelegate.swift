//
//  ListViewDelegate.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import Foundation

protocol ListViewDelegate: NSObjectProtocol {
    func dataWasLoaded(_ data: [LoadedData])
    func showDetailVC(_ data: LoadedData)
}

extension ListViewDelegate {
    func dataWasLoaded(_ data: [LoadedData]) {
    }
}
