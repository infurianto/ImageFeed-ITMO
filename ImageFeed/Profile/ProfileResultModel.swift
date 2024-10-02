//
//  ProfileResultModel.swift
//  ImageFeed
//
//  Created by infurianto on 02.10.2024.
//

import Foundation

struct ProfileResult: Codable {
    let userName: String
    let firstName: String
    let lastName: String?
    let bio: String?

    private enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}
 
