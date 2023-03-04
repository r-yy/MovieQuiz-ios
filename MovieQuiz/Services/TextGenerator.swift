//
//  TextGenerator.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 16.02.2023.
//

import Foundation

final class TextGenerator {
    
    private func randomText(rating: Int) -> (String, Bool) {
        let index = Bool.random()
        
        if index {
            return ("Рейтинг этого фильма больше, чем \(rating)?",
                    index)
        } else {
            return ("Рейтинг этого фильма меньше, чем \(rating)?",
                    index)
        }

    }
    
    func textGenerator(rating: Float) -> (String, Bool) {
        var text: String
        var correctAnswer: Bool
        
        var randomRating = (6...9).randomElement() ?? 0
        
        if rating == Float(randomRating) {
            randomRating -= 1
        }
                    
        let randomText = randomText(rating: randomRating)
        
        text = randomText.0
        
        if randomText.1 {
            correctAnswer = rating > Float(randomRating)
        } else {
            correctAnswer = rating < Float(randomRating)
        }
        
        return (text, correctAnswer)
    }
}
