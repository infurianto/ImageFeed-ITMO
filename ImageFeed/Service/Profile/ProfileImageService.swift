//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by infurianto on 02.10.2024.
//

import Foundation

final class ProfileImageService {

    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    private init() {}

    private (set) var avatarUrl: String?

    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private let oauth2TokenStorage = OAuth2TokenStorage.shared

    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    ){
        assert(Thread.isMainThread)
        if avatarUrl != nil { return }
        task?.cancel()
        guard let token = oauth2TokenStorage.token,
              let request = profileImageRequest(token: token, username: username) else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let avatarUrl = ProfileImage(callData: body)
                self.avatarUrl = avatarUrl.smallImage["large"]
                completion(.success(self.avatarUrl ?? ""))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self.avatarUrl as Any])
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

private extension ProfileImageService {
    private func profileImageRequest(token: String, username: String) -> URLRequest? {
        guard let url = URL(
            string: "\(Constants.defaultBaseURL)" + "/users/" + username)
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
