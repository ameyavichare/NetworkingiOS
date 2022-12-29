//
//  ViewController.swift
//  NetworkingBasicURLSession
//
//  Created by Admin on 25/12/22.
//

import UIKit
import Alamofire

final class MovieListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var movieList: MovieListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getMovieNamesViaURLSession()
//        getMovieNamesViaAlamofire()
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

// MARK: - API CALLS
extension MovieListViewController {
    private func getMovieNamesViaURLSession() {
        let apiKey: String = "f8058b85ec8c98aedde7ca3fea3a8220"
        let url: URL = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=1")!

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "x-app-code": "MOBIOS3"
        ] // just for explaination
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // just for explaination

        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self: MovieListViewController = self else { return }
            if let data: Data = data {
                if let movieList: MovieListResponse = try? JSONDecoder().decode(MovieListResponse.self, from: data) {
                    print(movieList)
                    self.movieList = movieList
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("Invalid Response")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }

        task.resume()
    }
    
    private func getMovieNamesViaAlamofire() {
        let apiKey: String = "f8058b85ec8c98aedde7ca3fea3a8220"
        let url: URL = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=1")!

        Alamofire.request(url, method: .get, encoding: JSONEncoding.default)
            .responseData { [weak self] response in
                guard let self: MovieListViewController = self else { return }
                if let data: Data = response.data {
                    if let movieList: MovieListResponse = try? JSONDecoder().decode(MovieListResponse.self, from: data) {
                        print(movieList)
                        self.movieList = movieList
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("Invalid Response")
                    }
                }
            }
    }
}

//MARK: - Table view delegate & datasource
extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let moviesCount: Int = movieList?.results.count {
            return moviesCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieListCell", for: indexPath)
        if let movieList: MovieListResponse = movieList,
           let movie: Movie = movieList.results.safelyGetElement(atIndex: indexPath.row),
           let movieName: String = movie.original_title {
            cell.textLabel?.text = movieName
        }
        
        return cell
    }
}
