//
//  AlertPresenterProtocol.swift
//  ImageFeed
//
//  Created by infurianto on 02.10.2024.
//

import Foundation

protocol AlertPresenterProtocol: AnyObject {
    func showError(for model: AlertModel)
}
