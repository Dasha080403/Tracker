import UIKit

// MARK: - Protocol
protocol NewTrackerViewControllerDelegate: AnyObject {
    func didCreateTracker(_ tracker: Tracker, categoryName: String)
}

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = [] 
    private var currentDate: Date = Date()
    
    // MARK: - UI Elements
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        return collection
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let searchTextField: UISearchTextField = {
        let field = UISearchTextField()
        field.placeholder = "Поиск"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let stubImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "star"))
        imageView.translatesAutoresizingMaskIntoConstraints =  false
        return imageView
    }()
    
    private let stubLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints =  false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
        setupCollectionView()
        reloadData()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Трекеры"
        
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(didTapAddButton)
        )
        addButton.tintColor = .black
        navigationItem.leftBarButtonItem = addButton
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
        view.addSubview(stubImageView)
        view.addSubview(stubLabel)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    // MARK: - Actions
    @objc private func didTapAddButton() {
        let choiceVC = TrackerTypeViewController() 
        choiceVC.delegate = self
        let navVC = UINavigationController(rootViewController: choiceVC)
        present(navVC, animated: true)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        reloadData()
    }
    
    @objc private func searchTextChanged() {
        reloadData()
    }
    
    // MARK: - Business Logic (Filtering)
    private func reloadData() {
        // 1. Получаем день недели из календаря (1 - вс, 2 - пн...)
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: currentDate)
        let weekDayEnum = WeekDay(rawValue: filterWeekday) // Предполагаем, что у вас есть такой Enum
        
        let searchText = searchTextField.text?.lowercased() ?? ""
        
        // 2. Фильтруем категории
        visibleCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                // Фильтр по тексту
                let textCondition = searchText.isEmpty || tracker.name.lowercased().contains(searchText)
                
                // Фильтр по расписанию (если nil - показываем всегда, иначе - по дням)
                let dateCondition = tracker.schedule?.contains(where: { $0 == weekDayEnum }) ?? true
                
                return textCondition && dateCondition
            }
            
            if filteredTrackers.isEmpty { return nil }
            return TrackerCategory(title: category.title, trackers: filteredTrackers)
        }
        
        // 3. Управляем плейсхолдером (заглушкой)
        let shouldShowStub = visibleCategories.isEmpty
        stubImageView.isHidden = !shouldShowStub
        stubLabel.isHidden = !shouldShowStub
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        
        // Проверяем, выполнен ли трекер сегодня
        let isCompleted = completedTrackers.contains {
            $0.id == tracker.id && calendar.isDate($0.date, inSameDayAs: currentDate)
        }
        
        cell.configure(with: tracker, isCompleted: isCompleted, completedDays: 0) // Добавьте свою логику подсчета дней
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SupplementaryView else {
            return UICollectionReusableView()
        }
        header.titleLabel.text = visibleCategories[indexPath.section].title
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 41) / 2 // 16+16 (отступы) + 9 (между ячейками)
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
}

// MARK: - NewTrackerViewControllerDelegate
extension TrackersViewController: NewTrackerViewControllerDelegate {
    func didCreateTracker(_ tracker: Tracker, categoryName: String) {
        dismiss(animated: true)
        
        if let index = categories.firstIndex(where: { $0.title == categoryName }) {
            var trackers = categories[index].trackers
            trackers.append(tracker)
            categories[index] = TrackerCategory(title: categoryName, trackers: trackers)
        } else {
            let newCategory = TrackerCategory(title: categoryName, trackers: [tracker])
            categories.append(newCategory)
        }
        
        reloadData()
    }
}
