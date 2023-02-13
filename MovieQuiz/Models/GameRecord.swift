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
        
        let currentGameResult = Double(game.correct) / Double(game.total)
        let bestGameResult = Double(self.correct) / Double(self.total)
        
        let bestCorrect = currentGameResult > bestGameResult ? game.correct : self.correct
        
        return GameRecord(correct: bestCorrect,
                          total: self.total,
                          date: self.date)
    }
}
