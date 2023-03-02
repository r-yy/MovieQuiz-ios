//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 02.02.2023.
//

import UIKit

final class ResultAlertPresenter: AlertProtocol {
    
    weak var viewController: UIViewController?
        
    func show(quiz result: AlertModel) {

        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)

        let action = UIAlertAction(
            title: result.buttonText, style: .default, handler: { _ in
                result.completition?()
        })

        alert.addAction(action)
        alert.view.accessibilityIdentifier = "ResultAlert"
        viewController?.present(alert, animated: true, completion: nil)
    }
}
