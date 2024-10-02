//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by infurianto on 01.09.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let avatarImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "placeholder")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "logout_button"), for: .normal)
        button.tintColor = .ypRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImageView()
        setUserName()
        setLoginName()
        setDescription()
        setLogoutButton()
        updateProfile(profileService.profile)
    }
}
    
extension ProfileViewController {
    private func updateProfile(_ profile: Profile?) {
           guard let profile = profile else { return }
           nameLabel.text = profile.name
           loginNameLabel.text = profile.loginName
           descriptionLabel.text = profile.bio

           profileImageServiceObserver = NotificationCenter.default.addObserver(
               forName: ProfileImageService.didChangeNotification,
               object: nil,
               queue: .main
           ) { [weak self] _ in
               guard let self = self else { return }
               self.updateAvatar()
           }
           updateAvatar()
       }
    
    private func setImageView() {
        view.addSubview(avatarImage)
        avatarImage.layer.cornerRadius = 35
        NSLayoutConstraint.activate([
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }

    private func setUserName() {
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16)
        ])
    }

    private func setLoginName() {
        view.addSubview(loginNameLabel)
        NSLayoutConstraint.activate([
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }

    private func setDescription() {
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: loginNameLabel.trailingAnchor)
        ])
    }
    
    @objc private func didTapLogoutButton() {
        // TODO: будет сделано в следующем спринте
        // OAuth2TokenStorage.shared.token = nil
    }
    
    private func setLogoutButton() {
        view.addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)

        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarImage.trailingAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor)
        ])
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarUrl,
            let url = URL(string: profileImageURL) else { return }

        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()

        let processor = RoundCornerImageProcessor(cornerRadius: 60)
        avatarImage.kf.indicatorType = .activity
        avatarImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [.processor(processor)]
        ) {
            result in
            switch result {
            case .success(let value):
                print(value.image)
            case .failure(let error):
                print(error)
            }
        }
    }
}
