//
//  ApiCaller.swift
//  News
//
//  Created by Ziya Zaidov on 11.12.2023.
//

import Foundation

final class ApiCaller {
    
    static let shared = ApiCaller()
    
    struct Constants {
        static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=e21aada007964ccda657ac686a0618a5")
        static let searchURL = "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=e21aada007964ccda657ac686a0618a5&q="
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping(Result<[Article],Error>) -> Void) {
        
        guard let url = Constants.topHeadLinesURL else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Article count: \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func searchURL(wirh query: String, completion: @escaping(Result<[Article],Error>) -> Void) {
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let urlString = Constants.searchURL + query
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Article count: \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
