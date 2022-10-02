//
//  DetailViewPresenter.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import Foundation

class DetailViewPresenter: NSObject {
    func saveDataToStorage(_ data: LoadedData) {
        CoreDataService.standart.save(model: data)
    }
    
    func containsId(_ id: String, completion: @escaping (_ response: Bool) -> Void) {
        let data = CoreDataService.standart.fetch()
        data?.forEach({ object in
            guard object.uuid.uuidString == id else { return }
            completion(true)
        })
    }
}
