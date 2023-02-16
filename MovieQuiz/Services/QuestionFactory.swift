//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 01.02.2023.
//

import UIKit

final class QuestionFactory: QuestionFactoryProtocol {
    
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    
//    private let questions: [QuizQuestion] = [
//            QuizQuestion(
//                image: "The Godfather",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//            QuizQuestion(
//                image: "The Dark Knight",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//            QuizQuestion(
//                image: "Kill Bill",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//            QuizQuestion(
//                image: "The Avengers",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//            QuizQuestion(
//                image: "Deadpool",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//            QuizQuestion(
//                image: "The Green Knight",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: true),
//            QuizQuestion(
//                image: "Old",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: false),
//            QuizQuestion(
//                image: "The Ice Age Adventures of Buck Wild",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: false),
//            QuizQuestion(
//                image: "Tesla",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: false),
//            QuizQuestion(
//                image: "Vivarium",
//                text: "Рейтинг этого фильма больше чем 6?",
//                correctAnswer: false)
//        ]
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else {
                return
                
            }
            
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let textGenerator = TextGenerator().textGenerator(rating: rating)
            
            let correctAnswer = textGenerator.1
            let text = textGenerator.0
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch result {
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                }
            }
        }
    }
}

