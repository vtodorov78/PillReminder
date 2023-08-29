//
//  InfoCell.swift
//  PillReminder
//
//  Created by Vladimir Todorov on 30.08.23.
//

import UIKit

class InfoCell: UITableViewCell {
    
    // MARK: - Properties
    
   static let reuseIdentifier = "InfoCell"
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(rightLabel)
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
