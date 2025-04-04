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
        imageView.image = AppCache.shared.user?.icon
        return imageView
    }()

    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.textColor = .label
        label.text = AppCache.shared.user?.name
        return label
    }()

    private(set) lazy var dangerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .systemRed
        label.text = "-- Внимание! Опасная зона! --"
        return label
    }()

    private(set) lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.setTitle("Удалить аккаунт", for: .normal)
        button.addAction(UIAction { [weak self] _ in
            guard let personID = AppCache.shared.user?.id else { return }
            self?.onDeleteAccount(for: personID)
        }, for: .touchUpInside)
        return button
    }()

    func mock() {
        print("adadasds")
    }

    func onDeleteAccount(for personId: UUID) {
        let personNet = PersonNetwork()
        print("rfradsfa")
        personNet.deleteAccount(with: personId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    AppCache.shared.clearCache { _ in }
                    UserDataCache().deleteUserInfo()

                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let delegate = scene.delegate as? SceneDelegate {
                        let loginVC = AuthViewController()
                        let nav = UINavigationController(rootViewController: loginVC)
                        delegate.window?.rootViewController = nav
                    }

                case .failure(let error):
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
        [avatarImageView, nameLabel, deleteButton, dangerLabel].forEach(self.addSubview)
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
