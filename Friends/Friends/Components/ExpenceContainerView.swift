//
//  ExpenceContainerView.swift
//  Friends
//
//  Created by Алёна Максимова on 26.03.2025.
//

import UIKit
import SnapKit

final class ExpenceContainerView: UIView {
    
    var title : String = "Затраты" {
        didSet {
            titleLable.text = title
        }
    }
    
    var placeholder : String = "Сумма" {
        didSet {
            textFieldView.placeholder = placeholder
        }
    }
    
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        
        return label
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        return view
    }()
    
    private lazy var textFieldView: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textColor = .label
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
        textFieldView.delegate = self
        
        [titleLable, lineView, textFieldView].forEach(self.addSubview)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.leading.equalToSuperview().inset(8)
        }
        
        titleLable.snp.makeConstraints { make in
            make.bottom.equalTo(lineView.snp.top).inset(-8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        textFieldView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(32)
        }
    }
}

extension ExpenceContainerView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
