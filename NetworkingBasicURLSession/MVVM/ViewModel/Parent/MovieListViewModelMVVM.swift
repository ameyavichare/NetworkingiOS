//
//  MovieListViewModelMVVM.swift
//  NetworkingBasic
//
//  Created by Ameya Vichare on 29/12/22.
//

import Foundation

final class MovieListViewModelMVVM {
    private let service: WebService = WebService()
    private(set) var dataSource: [MovieViewModel] = []
    weak var delegate: MovieListViewModelMVVMDelegate?
}

protocol MovieListViewModelMVVMDelegate: AnyObject {
    func reloadTableView()
}

extension MovieListViewModelMVVM {
    func prepareForInitialization() {
        self.fetchMovies()
    }
    
    private func fetchMovies() {
        let urlString = WebServiceConstants.baseURL + WebServiceConstants.movieListAPI + "api_key=\(apiKey)" + "&language=en-US" + "&page=1"
        
        guard let url = URL(string: urlString) else { return }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "x-app-code": "MOBIOS3"
        ] // just for explaination
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // just for explaination

        service.loadMovies(urlRequest: request) { [weak self] result in
            guard let self: MovieListViewModelMVVM = self else { return }
            switch result {
            case .success(let movieList):
                self.prepareDatasource(movieList: movieList)
                
            case .failure(let error):
                // Handle error here like showing a error popup etc.
                break

            }
        }
    }
}

extension MovieListViewModelMVVM {
    private func prepareDatasource(movieList: MovieListResponse) {
        self.dataSource = movieList.results.map({
            MovieViewModel($0)
        })
        self.delegate?.reloadTableView()
    }
    
    func vmAtIndex(_ index: Int) -> MovieViewModel? {
        dataSource.safelyGetElement(atIndex: index)
    }
    
    var numberOfSections: Int {
        1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        self.dataSource.count
    }
}
