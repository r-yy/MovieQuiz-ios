//
//  TextGenerator.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 16.02.2023.
//

import Foundation

final class TextGenerator {
    
    private func randomText(rating: Int) -> (String, Int) {
        let index = [0, 1].randomElement() ?? 0
        switch index {
        case 0:
            return ("Рейтинг этого фильма меньше, чем \(rating)?",
                    index)
        default:
            return ("Рейтинг этого фильма больше, чем \(rating)?",
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
        
        switch randomText.1 {
        case 0:
            correctAnswer = rating < Float(randomRating)
        default:
            correctAnswer = rating > Float(randomRating)
        }
        text = randomText.0
        
        return (text, correctAnswer)
    }
}
