//
//  FinanceViewController.swift
//  Friends
//
//  Created by Савва Пономарев on 26.03.2025.
//

import UIKit
import SnapKit

class FinanceViewController: UIViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        financeView.backgroundColor = .background
        addTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.subviews.forEach { subview in
                if subview is UILabel {
                    subview.removeFromSuperview()
                }
            }
        }
    }

    override func loadView() {
        self.view = FinanceView()
    }

    // MARK: - Properties

    private var financeView: FinanceView {
        guard let view = view as? FinanceView else {
            assertionFailure("Failed to dequeue FinanceView")
            return FinanceView()
        }
        return view
    }

    // MARK: - Actions

    @objc func onChange() {
        financeView.toogle()
    }

    @objc func onAddNewdebt() {
        let modalViewController = NewExpenseModalViewController()
        let navigationController = UINavigationController(rootViewController: modalViewController)
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.sheetPresentationController?.prefersGrabberVisible = true
        present(navigationController, animated: true)
    }

    // MARK: - Setup Methods

    private func addTargets() {
        financeView.segmentController.addTarget(self, action: #selector(onChange), for: .valueChanged)
        financeView.addDebtButton.addTarget(self, action: #selector(onAddNewdebt), for: .touchUpInside)
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false

        let titleLabel = UILabel()
        titleLabel.text = "Деньги"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(navigationBar.snp.leading).offset(16)
                make.centerY.equalTo(navigationBar.snp.centerY)
                make.trailing.lessThanOrEqualTo(navigationBar.snp.trailing).offset(-16)
            }
        }

        let avatarButton = UIButton(type: .custom)
        avatarButton.setImage(UIImage(named: "image"), for: .normal) // TODO: load user image
        avatarButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        avatarButton.clipsToBounds = true
        avatarButton.layer.cornerRadius = 20

        avatarButton.addAction(UIAction { [weak self] _ in
            let profileVC = ProfileViewController()
            self?.navigationItem.backButtonTitle = "Назад"
            self?.navigationController?.pushViewController(profileVC, animated: true)
        }, for: .touchUpInside)

        let buttonContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        buttonContainerView.addSubview(avatarButton)

        avatarButton.center = CGPoint(x: buttonContainerView.bounds.midX, y: buttonContainerView.bounds.midY)

        let barButtonItem = UIBarButtonItem(customView: buttonContainerView)
        navigationItem.rightBarButtonItem = barButtonItem

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        appearance.shadowColor = nil

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
}
