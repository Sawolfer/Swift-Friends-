//
//  ExpenseGroupView.swift
//  Friends
//
//  Created by Алёна Максимова on 26.03.2025.
//

import UIKit
import SnapKit

final class ExpenseGroupView: UIView {
    
    private lazy var moneyContainerView = ExpenceContainerView()
    private lazy var participansContainerView = ExpenceContainerView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        moneyContainerView.title = "Затраты"
        moneyContainerView.placeholder = "Сумма"
        participansContainerView.title = "Участники"
        participansContainerView.placeholder = "Количество"
        
        [moneyContainerView, participansContainerView].forEach(self.addSubview)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        moneyContainerView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(12).dividedBy(2)
            make.height.equalTo(100)
        }
        
        participansContainerView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(12).dividedBy(2)
            make.height.equalTo(100)
        }
    }
}
