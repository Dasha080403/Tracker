//
//  ColorCell.swift
//  Tracker
//
//  Created by Дарья Савинкина on 29.03.2026.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    static let identifier = "ColorCell"
    private let colorView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        contentView.layer.borderWidth = 3
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.clear.cgColor
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(color: UIColor) {
        colorView.backgroundColor = color
    }
    
    func setSelected(_ isSelected: Bool, color: UIColor) {
        contentView.layer.borderColor = isSelected ? color.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
    }
}

