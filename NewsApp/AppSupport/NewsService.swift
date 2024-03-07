//
//  NewsService.swift
//

import Foundation

struct NewsReponse: Codable {
    let articles: [HeadlinesModel]
    
    enum CodingKeys: String, CodingKey {
        case articles = "articles"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        articles = try values.decodeIfPresent([HeadlinesModel].self , forKey: .articles) ?? []
    }
}

struct SourcesReponse: Codable {
    let sources: [NewsSourcesModel]
    
    enum CodingKeys: String, CodingKey {
        case sources = "sources"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sources = try values.decodeIfPresent([NewsSourcesModel].self , forKey: .sources) ?? []
    }
}

final class NewsService {
    
    private enum Endpoint {
        case sources
        case allNews
        
        var path: String {
            switch self {
            case .sources: return "top-headlines/sources"
            case .allNews: return "top-headlines"
            }
        }
    }
    
    private static func getUrl(_ endpoint: Endpoint) -> String {
        let baseUrl = "https://newsapi.org/v2/"
        let apiKey = "?apiKey=0353650ae5134c759d91ef72b5046fde"
        
        switch endpoint {
        case .allNews:
            return "\(baseUrl)\(Endpoint.allNews.path)\(apiKey)&language=en"
        case .sources:
            return "\(baseUrl)\(Endpoint.sources.path)\(apiKey)"
        }
        
    }
    
    static func getNews(completion: @escaping (Result<[HeadlinesModel], Error>) -> Void) {
        var source = NewsSourceManager.getNewsSource()
        source = source.isEmpty ? "" : "&sources=\(source)"
        guard Reachability.isConnectedToNetwork(),
              let url = URL(string: "\(NewsService.getUrl(.allNews))\(source)") else {
            completion(.failure(CustomError.noConnection))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(#function, "Request: \(request)\nError: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(CustomError.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(NewsReponse.self, from: data)
                completion(.success(response.articles))
            } catch let error {
                print(#function, "Request: \(request)\nError: \(error)")
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    
    static func getSources(completion: @escaping (Result<[NewsSourcesModel], Error>) -> Void) {
        guard Reachability.isConnectedToNetwork(),
              let url = URL(string: NewsService.getUrl(.sources)) else {
            completion(.failure(CustomError.noConnection))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(#function, "Request: \(request)\nError: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(CustomError.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(SourcesReponse.self, from: data)
                completion(.success(response.sources))
            } catch let error {
                print(#function, "Request: \(request)\nError: \(error)")
                completion(.failure(error))
            }
            
        }.resume()
    }
}

final class NewsSourceManager {
    static let sourceKey = "SOURCE"
    static func getNewsSource() -> String {
        UserDefaults.standard.string(forKey: sourceKey) ?? ""
    }
    
    static func setNewsSource(_ source: String) {
        UserDefaults.standard.set(source, forKey: sourceKey)
    }
}
