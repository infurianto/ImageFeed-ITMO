//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by infurianto on 02.10.2024.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    private weak var delegate: UIViewController?

    init(delegate: UIViewController) {
        self.delegate = delegate
    }

    func showError(for model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            
            preferredStyle: .alert)
        let action = UIAlertAction(
             title: model.buttonText,
             style: .default) { _ in
                 model.completion()
             }
         alert.addAction(action)

         delegate?.present(alert, animated: true)
     }
 }
