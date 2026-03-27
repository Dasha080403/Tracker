//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Дарья Савинкина on 22.03.2026.
//
import UIKit

final class TrackersViewController: UIViewController {
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = Date()
    
    private let contentView = TrackersView()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.layer.cornerRadius = 8
        picker.clipsToBounds = true
        picker.calendar.firstWeekday = 2
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        contentView.collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        filterTrackersByDate()
    }
    
    private func setupNavBar() {
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let datePickerItem = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = datePickerItem
        
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapAddButton)
        )
        addButton.tintColor = .black
        navigationItem.leftBarButtonItem = addButton
    }
    
    private func updatePlaceholder() {
        contentView.showPlaceholder(visibleCategories.isEmpty)
    }
    
    @objc private func didTapAddButton() {
        let newHabitVC = NewHabitViewController()
        newHabitVC.delegate = self
        let navVC = UINavigationController(rootViewController: newHabitVC)
        present(navVC, animated: true)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        filterTrackersByDate()
    }
    
    private func filterTrackersByDate() {
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: currentDate)
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                guard let schedule = tracker.schedule else { return true }
                
                return schedule.contains { (weekDay: WeekDay) in
                    return weekDay.calendarDayNumber == filterWeekday
                }
            }
            
            if trackers.isEmpty { return nil }
            return TrackerCategory(title: category.title, trackers: trackers)
        }
        
        contentView.collectionView.reloadData()
        updatePlaceholder()
    }
}
    
    extension TrackersViewController: UICollectionViewDataSource {
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return visibleCategories.count
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return visibleCategories[section].trackers.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else {
                return UICollectionViewCell()
            }
            
            let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
            
            let isCompletedToday = completedTrackers.contains {
                $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate)
            }
            
            let completedDays = completedTrackers.filter { $0.trackerId == tracker.id }.count
            
            cell.delegate = self
            cell.configure(with: tracker, isCompletedToday: isCompletedToday, completedDays: completedDays, indexPath: indexPath)
            
            return cell
        }
    }

    
    extension TrackersViewController: UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let padding: CGFloat = 16
            let availableWidth = collectionView.frame.width - (padding * 3)
            let cellWidth = availableWidth / 2
            return CGSize(width: cellWidth, height: 148)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 9
        }
    }

    
    extension TrackersViewController: NewHabitViewControllerDelegate {
        
        func didCreateTracker(_ tracker: Tracker, categoryName: String) {
            if let index = categories.firstIndex(where: { $0.title == categoryName }) {
                var trackers = categories[index].trackers
                trackers.append(tracker)
                let updatedCategory = TrackerCategory(title: categoryName, trackers: trackers)
                categories[index] = updatedCategory
            } else {
                let newCategory = TrackerCategory(title: categoryName, trackers: [tracker])
                categories.append(newCategory)
            }
            
            filterTrackersByDate()
            dismiss(animated: true)
        }
    }

extension TrackersViewController: TrackerCellDelegate {
    
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        if currentDate > Date() { return }

                let trackerRecord = TrackerRecord(trackerId: id, date: currentDate)
                completedTrackers.append(trackerRecord)
                
                contentView.collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll {
            $0.trackerId == id && Calendar.current.isDate($0.date, inSameDayAs: currentDate)
        }
        contentView.collectionView.reloadItems(at: [indexPath])
    }
}
