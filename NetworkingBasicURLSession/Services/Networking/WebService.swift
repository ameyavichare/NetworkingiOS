//
//  WebService.swift
//  NetworkingBasic
//
//  Created by Ameya Vichare on 29/12/22.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case parsingError
    case invalidData
    case unknown
}

///Api endpoints & base url
struct WebServiceConstants {
    static let baseURL = "https://api.themoviedb.org/3/movie/"
    static let movieListAPI = "now_playing?"
}

final class WebService {
    func loadMovies(urlRequest: URLRequest, completionHandler: @escaping (Result<MovieListResponse, NetworkError>) -> Void) {
        guard let url: URL = urlRequest.url else { return completionHandler(.failure(.badURL)) }
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data: Data = data {
                if let movieList: MovieListResponse = try? JSONDecoder().decode(MovieListResponse.self, from: data) {
                    return completionHandler(.success(movieList))
                } else {
                    return completionHandler(.failure(.parsingError))
                }
            } else if let _ = error {
                return completionHandler(.failure(.invalidData))
            }
        }

        task.resume()
        
        return completionHandler(.failure(.unknown))
    }
    
    /// Generic function
    func load<T: Decodable>(urlRequest: URLRequest, resourceType: T.Type, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url: URL = urlRequest.url else { return completionHandler(.failure(.badURL)) }
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data: Data = data {
                if let parsedData = try? JSONDecoder().decode(T.self, from: data) {
                    return completionHandler(.success(parsedData))
                } else {
                    return completionHandler(.failure(.parsingError))
                }
            } else if let _ = error {
                return completionHandler(.failure(.invalidData))
            }
        }

        task.resume()
        
        return completionHandler(.failure(.unknown))
    }
}
