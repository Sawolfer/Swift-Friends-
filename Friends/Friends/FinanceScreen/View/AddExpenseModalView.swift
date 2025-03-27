//
//  AddExpenseModalView.swift
//  Friends
//
//  Created by Алёна Максимова on 26.03.2025.
//

import UIKit
import SnapKit

final class AddExpenseModalView: UIView {
    
    private lazy var groupView = ExpenseGroupView()
    private(set) lazy var individualView = ExpenseIndividualView()
    
    private(set) lazy var typeExpenseControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Групповые", "Индивидуальные"])
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        individualView.isHidden = true
        [typeExpenseControl, groupView, individualView].forEach(self.addSubview)
    }
    
    func toggleViews() {
        groupView.isHidden.toggle()
        individualView.isHidden.toggle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        typeExpenseControl.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(36)
        }
        
        groupView.snp.makeConstraints { make in
            make.top.equalTo(typeExpenseControl.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        individualView.snp.makeConstraints { make in
            make.top.equalTo(typeExpenseControl.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}
