import UIKit

protocol NewHabitViewControllerDelegate: AnyObject {
    func didCreateTracker(_ tracker: Models.Tracker, categoryName: String)
}

final class NewHabitViewController: UIViewController {
    
    weak var delegate: NewHabitViewControllerDelegate?
    private let emojis = Models.TrackerResources.emojis
    private let colors = Models.TrackerResources.colors
    private var selectedSchedule: [Models.WeekDay] = []
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.isScrollEnabled = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите название трекера"
        tf.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3)
        tf.layer.cornerRadius = 16
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let limitLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = .red
        label.font = .systemFont(ofSize: 17)
        label.isHidden = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3)
        stack.layer.cornerRadius = 16
        stack.clipsToBounds = true
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var categoryButton = createMenuButton(title: "Категория")
    private lazy var scheduleButton = createMenuButton(title: "Расписание")
    
    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Отменить", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.red.cgColor
        btn.layer.cornerRadius = 16
        return btn
    }()
    
    private let createButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Создать", for: .normal)
        btn.backgroundColor = .gray
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 16
        btn.isEnabled = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Новая привычка"
        
        setupCollectionView()
        setupUI()
        setupActions()
        textField.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [textField, limitLabel, stackView, collectionView, buttonsStackView].forEach {
            contentView.addSubview($0)
        }
        
        stackView.addArrangedSubview(categoryButton)
        
        let separator = UIView()
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16)
        ])
        
        stackView.addArrangedSubview(scheduleButton)
        
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(createButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            limitLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            limitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            limitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 480),
            
            buttonsStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(openSchedule), for: .touchUpInside)
    }
    
    private func createMenuButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = .black
        
        let subtitleLabel = UILabel()
        subtitleLabel.font = .systemFont(ofSize: 17)
        subtitleLabel.textColor = .gray
        subtitleLabel.tag = 100
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.isUserInteractionEnabled = false
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            vStack.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16)
        ])
        
        return button
    }
    
    private func checkFullness() {
        let isTextNotEmpty = !(textField.text?.isEmpty ?? true)
        let isScheduleNotEmpty = !selectedSchedule.isEmpty
        let isEmojiSelected = selectedEmoji != nil
        let isColorSelected = selectedColor != nil
        
        if isTextNotEmpty && isScheduleNotEmpty && isEmojiSelected && isColorSelected {
            createButton.isEnabled = true
            createButton.backgroundColor = .black
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .gray
        }
    }
    
    @objc private func didTapCreateButton() {
        guard let text = textField.text, !text.isEmpty,
              let color = selectedColor,
              let emoji = selectedEmoji else { return }
        
        let newTracker = Models.Tracker(
            id: UUID(),
            name: text,
            color: color,
            emoji: emoji,
            schedule: selectedSchedule
        )
        
        delegate?.didCreateTracker(newTracker, categoryName: "Важное")
        dismiss(animated: true)
    }
    
    @objc private func openSchedule() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.delegate = self
        present(UINavigationController(rootViewController: scheduleVC), animated: true)
    }
    
    @objc private func cancelAction() {
        dismiss(animated: true)
    }
}

extension NewHabitViewController: ScheduleViewControllerDelegate {
    func didSelectDays(_ days: [Models.WeekDay]) {
        self.selectedSchedule = days
        let subtitleLabel = scheduleButton.viewWithTag(100) as? UILabel
        
        if days.count == 7 {
            subtitleLabel?.text = "Каждый день"
        } else {
            subtitleLabel?.text = days.map { $0.shortName }.joined(separator: ", ")
        }
        
        checkFullness()
    }
}

extension NewHabitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let isOverLimit = updatedText.count > 38
        limitLabel.isHidden = !isOverLimit
        
        DispatchQueue.main.async {
            self.checkFullness()
        }
        
        return updatedText.count <= 38
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewHabitViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? emojis.count : colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as? EmojiCell else { return UICollectionViewCell() }
            let emoji = emojis[indexPath.row]
            cell.titleLabel.text = emoji
            cell.setSelected(emoji == selectedEmoji)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
            let color = colors[indexPath.row]
            cell.configure(color: color)
            cell.setSelected(color == selectedColor, color: color)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width - 36) / 6
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedEmoji = emojis[indexPath.row]
        } else {
            selectedColor = colors[indexPath.row]
        }
        collectionView.reloadSections(IndexSet(integer: indexPath.section))
        checkFullness()
    }
}


