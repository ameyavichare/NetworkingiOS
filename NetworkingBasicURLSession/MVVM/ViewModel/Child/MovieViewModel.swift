//
//  MovieViewModel.swift
//  NetworkingBasic
//
//  Created by Ameya Vichare on 29/12/22.
//

import Foundation

struct MovieViewModel {
    private(set) var movie: Movie
}

extension MovieViewModel {
    init(_ movie: Movie) {
        self.movie = movie
    }
}

extension MovieViewModel {
    
    var id: Int {
        return self.movie.id ?? 0
    }
    
    var name: String {
        return self.movie.original_title ?? ""
    }
    
    var releaseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date: String = self.movie.release_date {
            let date = dateFormatter.date(from: date) ?? Date()
            dateFormatter.dateFormat = "dd MMMM, yyyy"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    var movieDescription: String {
        return self.movie.overview ?? ""
    }
    
    var posterImageURL: URL? {
        guard let posterPath = self.movie.poster_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500" + posterPath) ?? nil
    }
}
