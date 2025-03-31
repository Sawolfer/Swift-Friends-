//
//  ExpenseIndividualView.swift
//  Friends
//
//  Created by Алёна Максимова on 27.03.2025.
//

import UIKit
import SnapKit

final class ExpenseIndividualView: UIView {
//        TODO: вынести в константу
    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.layer.cornerRadius = 10
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal

        return searchBar
    }()
    
    private(set) lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.add, for: .normal)
        button.tintColor = .systemBlue
        button.isHidden = true
        
        return button
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.personCellIdentifier)
        tableView.layer.cornerRadius = 10
        tableView.keyboardDismissMode = .onDrag
        
        return tableView
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
        [searchBar, addButton, tableView].forEach(self.addSubview)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(14)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(22)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
        }
    }
}
