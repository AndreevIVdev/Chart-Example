//
//  NetworkingManager.swift
//  My Portfolio
//
//  Created by Илья Андреев on 18.02.2022.
//

import Foundation

public protocol NetworkProtocol: AnyObject {
    
    func fetchData(
        from url: URL,
        completed: @escaping (Result<Data, Error>) -> Void
    )
    
    func fetchDataAvoidingCache(
        from url: URL,
        completed: @escaping (Result<Data, Error>) -> Void
    )
    
    func fetchDataWithOutErrorHandling(
        from url: URL,
        completed: @escaping (Data?) -> Void
    )
    
    func getToken() -> String
}

public enum StockError: String, Error {
    
    case noData
    case stockError
    case urlError
    case invalidResponse
}


final class NetworkingManager: NetworkProtocol {
    
    let cache: NSCache<NSString, NSData> = .init()
    
    
    
    public func fetchData(
        from url: URL,
        completed: @escaping (Result<Data, Error>) -> Void
    ) {
        if let nsdata = cache.object(forKey: url.description as NSString) {
            completed(.success(Data(referencing: nsdata)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                completed(.failure(StockError.stockError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(StockError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(StockError.noData))
                return
            }
            
            self.cache.setObject(NSData(data: data), forKey: url.description as NSString)
            
            completed(.success(data))
        }
        .resume()
    }
    
    public func fetchDataAvoidingCache(
        from url: URL,
        completed: @escaping (Result<Data, Error>) -> Void
    ) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                completed(.failure(StockError.stockError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(StockError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(StockError.noData))
                return
            }
            
            self.cache.setObject(NSData(data: data), forKey: url.description as NSString)
            
            completed(.success(data))
        }
        .resume()
    }
    
    public func fetchDataWithOutErrorHandling(
        from url: URL,
        completed: @escaping (Data?) -> Void
    ) {
        completed(try? Data(contentsOf: url))
    }
    
    private func valueForAPIKey(named keyname: String) -> String {
        guard let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist") else { return "" }
        let plist = NSDictionary(contentsOfFile: filePath)
        let value = plist?.object(forKey: keyname) as? String
        return value ?? ""
    }
    
    func getToken() -> String {
        valueForAPIKey(named: "API_CLIENT_ID")
    }
}
