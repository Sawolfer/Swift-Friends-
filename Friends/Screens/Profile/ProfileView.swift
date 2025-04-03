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
        imageView.image = UIImage(systemName: "person.circle")
        return imageView
    }()

    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.textColor = .label
        label.text = "Alyona Maksimova"
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
        return button
    }()

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
