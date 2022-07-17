//
//  Repository.swift
//  IOS_Practical_Test
//
//  Created by IOTA INFOTECH LIMITED on 17/7/22.
//

import Foundation
class Helper {
    static let shared = Helper()
    let baseURL = "https://api.themoviedb.org/3/search/movie"
    let imageBase = "https://image.tmdb.org/t/p/original"
    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
}
