//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 11.02.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}
