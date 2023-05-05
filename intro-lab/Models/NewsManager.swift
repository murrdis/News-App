//
//  NewsManager.swift
//  intro-lab
//
//  Created by Диас Мурзагалиев on 04.02.2023.
//

import Foundation

struct NewsManager {
    // MARK: - Properties
    static let shared = NewsManager()
    let imageCache = NSCache<NSString, NSData> ()
    
    private let newsUrl = "https://newsapi.org/v2/top-headlines?country=us&apiKey=8023de0990394a2a9942c483caad5b38"
    
    // MARK: - Methods
    func getNews (completion: @escaping (Result<[Article], Error>) -> Void) {
        if let url = URL(string: newsUrl) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(NewsData.self, from: safeData)
                        
                        completion(.success(decodedData.articles))
                    } catch {
                        print(error)
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func getImage(_ urlString: String, completion: @escaping (Data?) -> Void) {
        if let url = URL(string: urlString) {
            if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
                completion(cachedImage as Data)
            } else {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let data = data {
                        self.imageCache.setObject(data as NSData, forKey: NSString(string: urlString))
                        completion(data)
                    }
                    
                }
                task.resume()
            }
        }
    }
}
