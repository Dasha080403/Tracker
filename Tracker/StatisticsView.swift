//
//  StatisticsView.swift
//  Tracker
//
//  Created by Дарья Савинкина on 22.03.2026.
//

import UIKit

final class StatisticsView: UIView {
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }

    private func setupUI() {
        backgroundColor = .white
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
