//
//  BannerView.swift
//  PillReminder
//
//  Created by Vladimir Todorov on 31.08.23.
//

import UIKit

class BannerView: UIView {
    
    // MARK: - Properties
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewComponents()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper funcitons
    
    func configureViewComponents() {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
            
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}
