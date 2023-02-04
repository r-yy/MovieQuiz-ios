//
//  AlertProtocol.swift
//  MovieQuiz
//
//  Created by Ramil Yanberdin on 04.02.2023.
//

import Foundation
import UIKit

protocol AlertProtocol {
    var viewController: UIViewController? { get set }
    func show(quiz: AlertModel)
}
