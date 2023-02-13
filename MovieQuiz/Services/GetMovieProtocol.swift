//
//  GetMovieProtocol.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 10.02.2023.
//

import Foundation

protocol GetMovieProtocol {
    func getMovie(from jsonString: String) -> Top?
}
