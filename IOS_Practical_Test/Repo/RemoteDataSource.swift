//
//  Repository.swift
//  IOS_Practical_Test
//
//  Created by IOTA INFOTECH LIMITED on 17/7/22.
//

import Foundation
import Combine

class RemoteDataSource{
    static let shared = RemoteDataSource()
    var cancelable = Set<AnyCancellable>()
    func getSearchMovieResponse(searchQuery: String) -> Future<MovieResponse, Error> {
        return Future{
            result in
            let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
            let plist = NSDictionary(contentsOfFile: filePath!)
            let param = ["api_key": plist?.object(forKey: "API_KEY") as? String ?? "", "query": searchQuery]
            var components = URLComponents(string: Helper.shared.baseURL)!
            components.queryItems = param.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap(Helper.shared.handleOutput)
                .decode(type: MovieResponse.self, decoder: JSONDecoder())
                .sink { (completion) in
                    switch completion {
                    case .finished:break
                    case .failure(let error):
                        result(.failure(error))
                    }
                } receiveValue: { movieResponse in
                    result(.success(movieResponse))
                }.store(in: &self.cancelable)
        }
    }
}
