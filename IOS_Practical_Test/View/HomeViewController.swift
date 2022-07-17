//
//  ViewController.swift
//  IOS_Practical_Test
//
//  Created by IOTA INFOTECH LIMITED on 17/7/22.
//

import UIKit
import Combine
class HomeViewController: UIViewController {
    let vm = MovieViewModel()
    var observers: [AnyCancellable] = []
    var movieList = [MovieResult]()
    @Published var searchQuery = "marvel"
    
    @IBOutlet weak var lbEmptyText: UILabel!
    @IBOutlet weak var emptyView: UIView!
    lazy var searchBar = UISearchBar(frame: .zero)
    @IBOutlet weak var movieTblList: UITableView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.delegate = self
        configureCollectionView()
        canSearch()
        callApiData()
        configureEmptyView()
        handleLoader()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        observers.forEach { cancelable in
            cancelable.cancel()
        }
    }
    func handleLoader(){
        vm.$isLoading.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [self] isLoading in
            if isLoading {
                self.loader.startAnimating()
            }else {
                self.loader.isHidden = true
            }
        }).store(in: &observers)
    }
    
    func canSearch(){
        $searchQuery.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] searchQuery in
            if !searchQuery.isEmpty {
                self?.vm.subscribeMovieList(searchQuery: searchQuery)
            }
        }).store(in: &observers)
    }
    func configureCollectionView(){
        movieTblList.delegate = self
        movieTblList.dataSource = self
        movieTblList.register(MovieTblViewCell.nibName(), forCellReuseIdentifier: MovieTblViewCell.identifier)
        movieTblList.separatorStyle = .none
        
    }
    func configureEmptyView(){
        vm.$movieList.receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] movieData in
                self?.emptyView.isHidden = movieData.count == 0 && !(self?.vm.isLoading)! ? false : true
            }).store(in: &observers)
    }
    
    func callApiData(){
        vm.$movieList.receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] movieData in
                self?.movieList = movieData
                self?.movieTblList.reloadData()
            }).store(in: &observers)
    }
    
    func configureNavigation(){
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        navigationItem.title = "Movie List"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            searchQuery = searchText
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.count > 2 {
            searchQuery = searchBar.text!
            searchBar.resignFirstResponder()
        }
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTblViewCell.identifier, for: indexPath) as? MovieTblViewCell else {
            fatalError()
        }
        cell.populateData(movie: movieList[indexPath.row])
        return cell
    }
}

