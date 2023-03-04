//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 11.02.2023.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func compareGames(currentGame game: GameRecord) -> GameRecord {
        
        let bestCorrect = [game.correct, self.correct].max() ?? self.correct
        
        let bestDate: Date
        if bestCorrect == game.correct {
            bestDate = game.date
        } else {
            bestDate = self.date
        }
        
        return GameRecord(correct: bestCorrect,
                          total: self.total,
                          date: bestDate)
    }
}
