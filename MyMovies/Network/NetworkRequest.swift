//
//  NetworkReqiest.swift
//  ItunesTestTask
//
//  Created by Данила on 08.04.2022.
//

import Foundation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    
    private init() {}
    
    let apiKey = "********"
    
    func requestData(searchName: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let sN = searchName
        
        let urlStr = "http://omdbapi.com/?apikey=\(apiKey)&s=" + sN
        
        
        guard let url = URL(string: urlStr ) else { return }
        
        print("requestData !")
        URLSession.shared.dataTask(with: url) { data, responce, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        .resume()
    }
    
    func requestDataPoster(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: urlString ) else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        .resume()
    }
}
