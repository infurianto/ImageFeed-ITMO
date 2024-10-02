//
//  ProfileService.swift
//  ImageFeed
//
//  Created by infurianto on 02.10.2024.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    
    private init() {}

    private var task: URLSessionTask?
    private let urlSession = URLSession.shared

    private(set) var profile: Profile?

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if profile != nil { return }
        task?.cancel()
        guard let request = profileRequest(token: token) else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (
            result: Result<ProfileResult,Error>
        ) in
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let profile = Profile(callData: body)
                    self.profile = profile
                    completion(.success(profile))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        self.task = task
        task.resume()
    }
}

private extension ProfileService {
    func profileRequest(token: String) -> URLRequest? {
        guard let url = URL(
            string: "\(Constants.defaultBaseURL)"
            + "/me")
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
