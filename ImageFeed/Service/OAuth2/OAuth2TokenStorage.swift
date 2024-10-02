//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by infurianto on 08.09.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Constants.tokenKey)
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: Constants.tokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Constants.tokenKey)
            }
        }
    }
}
