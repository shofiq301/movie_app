//
//  MovieViewModel.swift
//  IOS_Practical_Test
//
//  Created by IOTA INFOTECH LIMITED on 17/7/22.
//

import Foundation
import Combine

class MovieViewModel {
    @Published var movieList: [MovieResult] = []
    @Published var isLoading = true
    var cancelable = Set<AnyCancellable>()
    func subscribeMovieList(searchQuery: String){
        RemoteDataSource.shared.getSearchMovieResponse(searchQuery: searchQuery)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self]
                completion in
                switch(completion){
                case .finished:
                    self?.isLoading = false
                case .failure(let error):
                    self?.isLoading = false
                    print(String(describing: error))
                }
            }, receiveValue: { [weak self] result in
                self?.movieList = result.results
            }).store(in: &cancelable)
    }
}
