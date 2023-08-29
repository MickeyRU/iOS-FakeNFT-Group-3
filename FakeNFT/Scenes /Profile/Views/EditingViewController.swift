import UIKit

final class EditingViewController: UIViewController {
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // UIView с полупрозрачным фоном
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexString: "1A1B22").withAlphaComponent(0.6)
        view.layer.cornerRadius = 35
        return view
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton()
        let title = NSLocalizedString("changePhoto", comment: "Change Photo on Avatar")
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(changePhotoTapper), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel = createTextLabel()
    private lazy var nameTextView = createTextView()
    
    private lazy var descriptionLabel = createTextLabel()
    private lazy var descriptionTextView = createTextView()
    
    private lazy var webSiteLabel = createTextLabel()
    private lazy var webSiteTextView = createTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        loadUserData()
    }
    
    @objc
    private func exitButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func changePhotoTapper() {
        print("changePhotoTapper")
        // ToDo: - Логика смены фото пользователя.
    }
    
    private func setupViews() {
        [exitButton, userPhotoImageView, overlayView, changePhotoButton, nameLabel, nameTextView, descriptionLabel, descriptionTextView, webSiteLabel, webSiteTextView].forEach { view.addViewWithNoTAMIC($0) }
        
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exitButton.widthAnchor.constraint(equalToConstant: 42),
            exitButton.heightAnchor.constraint(equalToConstant: 42),
            
            userPhotoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            userPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 70),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 70),
            
            overlayView.topAnchor.constraint(equalTo: userPhotoImageView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: userPhotoImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor),
            
            changePhotoButton.topAnchor.constraint(equalTo: overlayView.topAnchor),
            changePhotoButton.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor),
            changePhotoButton.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
            changePhotoButton.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor, constant: 24),
            
            nameTextView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            nameTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: 24),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            
            webSiteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            webSiteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            webSiteLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            
            webSiteTextView.leadingAnchor.constraint(equalTo: webSiteLabel.leadingAnchor),
            webSiteTextView.trailingAnchor.constraint(equalTo: webSiteLabel.trailingAnchor),
            webSiteTextView.topAnchor.constraint(equalTo: webSiteLabel.bottomAnchor, constant: 8),

        ])
    }
    
    private func loadUserData() {
        // TODO: - после реализации MVVM этот метод подставляет в UI данные пользователя, которые в свою очередь берет из модели.
        self.userPhotoImageView.image = UIImage(named: "mockAvatar")
        self.nameLabel.text = "Имя"
        self.nameTextView.text = "Joaquin Phoenix"
        self.descriptionLabel.text = "Описание"
        self.descriptionTextView.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        self.webSiteLabel.text = "Сайт"
        self.webSiteTextView.text = "Joaquin Phoenix.com"
    }
}

// MARK: - Create UI Methods

extension EditingViewController {
    private func createTextLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.sfBold22
        return label
    }
    
    private func createTextView() -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.sfRegular17
        textView.backgroundColor = UIColor.init(hexString: "F7F7F8")
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 10, bottom: 11, right: 10)
        return textView
    }
}
