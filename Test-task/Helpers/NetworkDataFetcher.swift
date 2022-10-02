//
//  NetworkDataFetcher.swift
//  Test-task
//
//  Created by zz on 02.10.2022.
//

import Foundation

enum FetchState: String {
    case firstLaunch = "photos/random?count=30"
    case search = "search/photos?query="
}

class NetworkDataFetcher: NSObject {
    func loadFromNetwork(string: String, completion: @escaping (_ data: Data?) -> Void) {
        guard let url = URL(string: "\(Constants.defaultApiUrl)\(string)") else {
            completion(nil)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Client-ID \(Constants.apiKey)",
                            forHTTPHeaderField: Constants.headerField)
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(data)
        }.resume()
    }
    
    func getData(state: String, completion: @escaping (_ data: [LoadedData]?) -> Void) {
        loadFromNetwork(string: state) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(self.parser(data: data))
        }
    }
    
    private func parser(data: Data) -> [LoadedData]? {
        var objects = [LoadedData]()
        do {
            let results = try JSONDecoder().decode(FetchData.self, from: data)
            results.results.forEach { result in
                var object = LoadedData()
                object.dateCreate = result.createdAt
                object.url = result.urls.small
                object.nameAuthor = result.user.username
                object.location = result.user.location
                objects.append(object)
            }
        } catch {
            manualParse(data: data, objects: &objects)
            return objects
        }
        
        return objects
    }
    
    private func manualParse(data: Data, objects: inout [LoadedData]) {
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
            json.forEach { object in
                var loadedData = LoadedData()
                loadedData.dateCreate = object["created_at"] as? String
                loadedData.countOfDownloads = object["downloads"] as? Int
                let userData = object["user"] as? [String: Any]
                loadedData.nameAuthor = userData?["name"] as? String
                let locationData = object["location"] as? [String: Any]
                loadedData.location = locationData?["name"] as? String
                let urlData = object["urls"] as? [String: Any]
                loadedData.url = urlData?["small"] as? String
                objects.append(loadedData)
            }
        }
    }
}
