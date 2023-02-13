//
//  GetMovieService.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 09.02.2023.
//

import Foundation

final class GetMovieService: GetMovieProtocol {
    
    func getMovie(from jsonString: String) -> Top? {
      
        var movie: Top?
        
            do {
                let data = jsonString.data(using: .utf8)!
                movie = try JSONDecoder().decode(Top.self, from: data)
            } catch {
                print("Failed to parse: \(error.localizedDescription)")
            }
        return movie
    }
}
