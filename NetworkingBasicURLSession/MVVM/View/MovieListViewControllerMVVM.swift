//
//  MovieListViewControllerAdvanced.swift
//  NetworkingBasic
//
//  Created by Ameya Vichare on 29/12/22.
//

import UIKit

final class MovieListViewControllerMVVM: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: MovieListViewModelMVVM = MovieListViewModelMVVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        viewModel.prepareForInitialization()
    }
    
    private func setupView() {
        setupTableView()
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }

    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

//MARK: - Table view delegate & datasource
extension MovieListViewControllerMVVM: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let viewModel: MovieViewModel = self.viewModel.vmAtIndex(indexPath.row) {
            return cellForMovie(viewModel, indexPath: indexPath)
        }
        return UITableViewCell()
    }
    
    private func cellForMovie(_ viewModel: MovieViewModel, indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "movieListMVVMCell", for: indexPath)
        cell.textLabel?.text = viewModel.name
        return cell
    }
}

extension MovieListViewControllerMVVM: MovieListViewModelMVVMDelegate {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
