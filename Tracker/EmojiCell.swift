//
//  EmojiCell.swift
//  Tracker
//
//  Created by Дарья Савинкина on 29.03.2026.
//
import UIKit

final class EmojiCell: UICollectionViewCell {
    static let identifier = "EmojiCell"
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = .systemFont(ofSize: 32)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setSelected(_ isSelected: Bool) {
        contentView.backgroundColor = isSelected ? .lightGray : .clear
    }
}
