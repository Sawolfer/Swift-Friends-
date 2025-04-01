//
//  SegmentedControlView.swift
//  Friends
//
//  Created by Алексей on 26.03.2025.
//

import UIKit

final class SegmentedControlView: UIView {
    // MARK: - Constants

    private enum Constants {
        static let segmentedControlHeight: CGFloat = 32
    }

    // MARK: - Properties

    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Активные", "Архив"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = UIColor.systemGray5
        control.selectedSegmentTintColor = .white
        control.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
        return control
    }()
    var segmentChanged: ((Int) -> Void)?

    // MARK: - Iniitialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private functions

    private func setupUI() {
        addSubview(segmentedControl)

        segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.top.bottom.equalTo(self)
            make.height.equalTo(Constants.segmentedControlHeight)
        }

        segmentedControl.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
    }

    // MARK: - Actions
    @objc
    private func segmentValueChanged() {
        segmentChanged?(segmentedControl.selectedSegmentIndex)
    }
}
