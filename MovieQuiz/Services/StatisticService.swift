//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 11.02.2023.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, totalAccuracy, bestGame, gamesCount
    }
    private let userDefaults = UserDefaults.standard
    
    var totalAccuracy: Double {
        get {
            userDefaults.double(forKey: Keys.totalAccuracy.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.totalAccuracy.rawValue)
        }
    }
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        
        let currentGamesCount = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        self.gamesCount = currentGamesCount + 1
        
        let currentGame = GameRecord(correct: count,
                              total: amount,
                              date: Date())
        
        bestGame = currentGame.compareWith(bestGame)
        
        let bestTotalAccuracy = (Double(bestGame.correct) / Double(bestGame.total)) * 100
        totalAccuracy = bestTotalAccuracy
    }
}
