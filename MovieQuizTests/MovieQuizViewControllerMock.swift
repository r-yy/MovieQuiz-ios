//
//  MovieQuizViewControllerMock.swift
//  MovieQuizTests
//
//  Created by Ramil Yanberdin on 04.03.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showLoadingIndicator() {
    }
    
    func showNetworkError(message: String) {
    }
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
    }
    
    func show(quiz result: MovieQuiz.ResultAlertModel) {
    }
    
    func buttonsEnable(isEnabled: Bool) {
    }
    
    func highlightImageBorder(isCorrect: Bool) {
    }
    
    func disableImageBorder() {
    }
}

final class MovieQuizPresenterTest: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let text = "Question text"
        let question = QuizQuestion(image: emptyData,
                                    text: text,
                                    correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.text, text)
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
