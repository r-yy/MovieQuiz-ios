//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 15.02.2023.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    //MARK: - NetworkClient
    private let networkClient: NetworkRouting
    //MARK: - URL
    private var mostPopularMoviesURL: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_od0zkud1") else {
            preconditionFailure("Unable to construct mostPopularMoviesURL")
        }
        return url
    }
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
        networkClient.fetch(url: mostPopularMoviesURL) { result in
            
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let data):
                do {
                    let mostPopularMoviesFromData = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMoviesFromData))
                } catch {
                    handler(.failure(error))
                }
            }
        }
    }
}
