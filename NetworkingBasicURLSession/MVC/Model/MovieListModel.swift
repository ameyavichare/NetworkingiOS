//
//  MovieListModel.swift
//  NetworkingBasicURLSession
//
//  Created by Admin on 25/12/22.
//

import Foundation

struct MovieListResponse: Decodable {
    let results: [Movie]
    
//    enum CodingKeys: String, CodingKey {
//        case movies = "results"
//    }
}

struct Movie: Decodable {
    let id: Int?
    let original_title: String?
    let overview: String?
    let poster_path: String?
    let release_date: String?
}
