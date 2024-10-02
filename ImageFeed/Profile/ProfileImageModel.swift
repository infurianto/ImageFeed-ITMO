//
//  ProfileImageModel.swift
//  ImageFeed
//
//  Created by infurianto on 02.10.2024.
//

import Foundation

struct ProfileImage: Codable {
    let smallImage: [String:String]

    init(callData: UserResult) {
        self.smallImage = callData.profileImage
    }
}
