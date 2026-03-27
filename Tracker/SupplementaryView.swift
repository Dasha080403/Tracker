//
//  SupplementaryView.swift
//  Tracker
//
//  Created by Дарья Савинкина on 22.03.2026.
//

import UIKit

final class SupplementaryView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 19)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }

    func configure(with title: String) {
        titleLabel.text = title
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
