//
//  LoadedData.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import Foundation

struct LoadedData: Codable {
    var url: String?
    var nameAuthor: String?
    var dateCreate: String?
    var location: String?
    var countOfDownloads: Int?
    var uuid = UUID()
}

extension LoadedData: Hashable {
    static func == (lhs: LoadedData, rhs: LoadedData) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
