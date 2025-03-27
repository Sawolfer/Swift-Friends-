//
//  ExpenseIndividualView.swift
//  Friends
//
//  Created by Алёна Максимова on 27.03.2025.
//

import UIKit

final class ExpenseIndividualView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        [].forEach(self.addSubview)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
