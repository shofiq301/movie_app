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
    var cancelable = Set<AnyCancellable>()
    func subscribeMovieList(searchQuery: String){
        RemoteDataSource.shared.getSearchMovieResponse(searchQuery: searchQuery)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                completion in
                switch(completion){
                case .finished:break
                case .failure(let error):
                    print(String(describing: error))
                }
            }, receiveValue: { [weak self] result in
                self?.movieList = result.results
            }).store(in: &cancelable)
    }
}
