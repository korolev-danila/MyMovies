//
//  NetworkDataFetch.swift
//  ItunesTestTask
//
//  Created by Данила on 08.04.2022.
//

import Foundation

class NetworkDataFetch {
    static let shared = NetworkDataFetch()
    
    private init() {}
    
    func fetchMovie(searchName: String, responce: @escaping (MoviesModel?, Error?) -> Void) {
        
        NetworkRequest.shared.requestData(searchName: searchName) { result in
            switch result {
            case .success(let data):
                do {
                    print(data)
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    print(json)
                    
                    let movies = try JSONDecoder().decode(MoviesModel.self, from: data)
                    responce(movies, nil)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received reuesting data: \(error.localizedDescription)")
                responce(nil, error)
            }
        }
    }
}
