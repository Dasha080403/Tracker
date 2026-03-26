//
//  TrackerCell.swift
//  Tracker
//
//  Created by Дарья Савинкина on 25.03.2026.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackerCell: UICollectionViewCell {
    static let identifier = "TrackerCell"
    weak var delegate: TrackerCellDelegate?
    
    private var isCompletedToday: Bool = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    // Верхняя цветная часть (высота 90)
    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Эмодзи
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white.withAlphaComponent(0.3)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Название привычки (Задача 1: 143х34 внизу ячейки)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Нижняя часть (Задача 2: Прямоугольник 167х58 со счетчиком и кнопкой)
    private let managementView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 17 // половина от 34
        button.tintColor = .white
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubview(emojiLabel)
        cardView.addSubview(titleLabel)
        
        contentView.addSubview(managementView)
        managementView.addSubview(daysLabel)
        managementView.addSubview(plusButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Карточка (верх)
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            // Эмодзи
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            // Название (Размер 143х34, внизу cardView)
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            titleLabel.widthAnchor.constraint(equalToConstant: 143),
            titleLabel.heightAnchor.constraint(equalToConstant: 34),
            
            // Нижний прямоугольник (Размер 167х58)
            managementView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            managementView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            managementView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            managementView.heightAnchor.constraint(equalToConstant: 58),
            
            // Счетчик дней (Размер 101х18)
            daysLabel.leadingAnchor.constraint(equalTo: managementView.leadingAnchor, constant: 12),
            daysLabel.topAnchor.constraint(equalTo: managementView.topAnchor, constant: 16),
            daysLabel.widthAnchor.constraint(equalToConstant: 101),
            daysLabel.heightAnchor.constraint(equalToConstant: 18),
            
            // Кнопка плюс (Размер 34х34)
            plusButton.trailingAnchor.constraint(equalTo: managementView.trailingAnchor, constant: -12),
            plusButton.topAnchor.constraint(equalTo: managementView.topAnchor, constant: 8),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    func configure(with tracker: Tracker, isCompletedToday: Bool, completedDays: Int, indexPath: IndexPath) {
        self.trackerId = tracker.id
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        
        titleLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        cardView.backgroundColor = tracker.color
        plusButton.backgroundColor = tracker.color
        
        // Склонение слова "день"
        daysLabel.text = formatDays(completedDays)
        
        let image = isCompletedToday ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        plusButton.setImage(image, for: .normal)
        plusButton.alpha = isCompletedToday ? 0.3 : 1.0
    }
    
    private func formatDays(_ count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        if lastTwoDigits >= 11 && lastTwoDigits <= 19 { return "\(count) дней" }
        if lastDigit == 1 { return "\(count) день" }
        if lastDigit >= 2 && lastDigit <= 4 { return "\(count) дня" }
        return "\(count) дней"
    }
    
    @objc private func plusButtonTapped() {
        guard let trackerId = trackerId, let indexPath = indexPath else { return }
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
}
