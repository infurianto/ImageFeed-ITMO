//
//  UserResultModel.swift
//  ImageFeed
//
//  Created by infurianto on 02.10.2024.
//

import Foundation

struct UserResult: Codable {
    let profileImage: [String: String]

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
