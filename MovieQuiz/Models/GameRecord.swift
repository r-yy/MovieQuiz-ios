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
    
    func compareWith(_ bestGame: GameRecord) -> GameRecord {
        
        let bestCorrect = [bestGame.correct, self.correct].max() ?? bestGame.correct
        
        let bestDate: Date
        if bestCorrect == bestGame.correct {
            bestDate = bestGame.date
        } else {
            bestDate = self.date
        }
        
        return GameRecord(correct: bestCorrect,
                          total: self.total,
                          date: bestDate)
    }
}
