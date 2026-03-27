//
//  TrackersView.swift
//  Tracker
//
//  Created by Дарья Савинкина on 22.03.2026.
//

import UIKit

final class TrackersView: UIView {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        return collection
    }()
    
    private let placeholderImageView = UIImageView(image: UIImage(named: "star"))
    private let placeholderLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func setupUI() {
        backgroundColor = .white
        placeholderLabel.text = "Что будем отслеживать?"
        placeholderLabel.font = .systemFont(ofSize: 12)
        
        [collectionView, placeholderImageView, placeholderLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            placeholderImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func showPlaceholder(_ isVisible: Bool) {
        placeholderImageView.isHidden = !isVisible
        placeholderLabel.isHidden = !isVisible
        collectionView.isHidden = isVisible
    }
}
