//
//  ProfileView.swift
//  Friends
//
//  Created by Алёна Максимова on 03.04.2025.
//

import UIKit
import SnapKit

final class ProfileView: UIView {

    private(set) lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100
        imageView.image = AppCache.shared.user.icon
        return imageView
    }()

    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.textColor = .label
        label.text = AppCache.shared.user.name
        return label
    }()

    private(set) lazy var dangerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .systemRed
        label.text = "-- Внимание! Опасная зона! --"
        return label
    }()

    private(set) lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.setTitle("Выйти", for: .normal)
        button.addAction(UIAction { [weak self] _ in
            let personID = AppCache.shared.user.id
            self?.onLogout()
        }, for: .touchUpInside)
        return button
    }()

    
    private(set) lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.setTitle("Удалить аккаунт", for: .normal)
        button.addAction(UIAction { [weak self] _ in
            let personID = AppCache.shared.user.id
            self?.onDeleteAccount(for: personID)
        }, for: .touchUpInside)
        return button
    }()

    func mock() {
        print("adadasds")
    }

    func onLogout() {
        AppCache.shared.clear { _ in }
        UserDataCache().deleteUserInfo()

        DispatchQueue.main.async {
            let authVC = AuthViewController()
            let navController = UINavigationController(rootViewController: authVC)
            navController.modalPresentationStyle = .overFullScreen

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                window.rootViewController = navController
                window.makeKeyAndVisible()
            }
        }
    }

    func onDeleteAccount(for personId: UUID) {
        let personNet = PersonNetwork()
        print("rfradsfa")
        personNet.deleteAccount(with: personId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    AppCache.shared.clear { _ in }
                    UserDataCache().deleteUserInfo()

                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let delegate = scene.delegate as? SceneDelegate {
                        let loginVC = AuthViewController()
                        let nav = UINavigationController(rootViewController: loginVC)
                        delegate.window?.rootViewController = nav
                    }

                case .failure(_):
                    return
                }
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        [avatarImageView, nameLabel, logOutButton, deleteButton, dangerLabel].forEach(self.addSubview)
    }

    // MARK: - Constraints

    override func layoutSubviews() {
        super.layoutSubviews()

        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(200)
            make.centerX.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        logOutButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
        }

        deleteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(60)
        }

        dangerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(deleteButton.snp.top).inset(-20)
        }
    }
}

