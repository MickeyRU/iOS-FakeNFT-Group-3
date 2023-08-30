import UIKit

protocol EditingViewControllerProtocol: AnyObject {
    func updateUserProfile(userProfile: UserProfileModel)
}

final class EditingViewController: UIViewController {
    weak var delegate: EditingViewControllerProtocol?
    
    private var userProfile: UserProfileModel
    
    private lazy var nameLabel = createTextLabel()
    private lazy var nameTextView = createTextView()
    
    private lazy var descriptionLabel = createTextLabel()
    private lazy var descriptionTextView = createTextView()
    
    private lazy var webSiteLabel = createTextLabel()
    private lazy var webSiteTextView = createTextView()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
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
    
    private let userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexString: "1A1B22").withAlphaComponent(0.6)
        view.layer.cornerRadius = 35
        return view
    }()
    
    init(userProfile: UserProfileModel, delegate: EditingViewControllerProtocol) {
        self.userProfile = userProfile
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
        setupDelegates()
        loadUserProfile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveUserProfile()
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
    
    private func setupDelegates() {
        nameTextView.delegate = self
        descriptionTextView.delegate = self
        webSiteTextView.delegate = self
    }
    
    private func loadUserProfile() {
        self.userPhotoImageView.image = UIImage(named: "mockAvatar") // ToDo: - загрузка из сети по адресу
        self.nameLabel.text = NSLocalizedString("userName", comment: "")
        self.nameTextView.text = userProfile.name
        self.descriptionLabel.text = NSLocalizedString("discription", comment: "")
        self.descriptionTextView.text = userProfile.description
        self.webSiteLabel.text = NSLocalizedString("webSite", comment: "")
        self.webSiteTextView.text = userProfile.webSite
    }
    
    private func saveUserProfile() {
        delegate?.updateUserProfile(userProfile: userProfile)
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

// MARK: - UITextViewDelegate

extension EditingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        if textView == nameTextView {
            self.userProfile = createNewUserProfileModel(name: textView.text,
                                                         avatar: nil,
                                                         description: nil,
                                                         webSite: nil)
        } else if textView == descriptionTextView {
            self.userProfile = createNewUserProfileModel(name: nil,
                                                        avatar: nil,
                                                        description: textView.text,
                                                        webSite: nil)
        } else if textView == webSiteTextView {
            self.userProfile = createNewUserProfileModel(name: nil,
                                                        avatar: nil,
                                                        description: nil,
                                                        webSite: textView.text)
        }
    }
    
    private func createNewUserProfileModel(name: String?,
                                           avatar: String?,
                                           description: String?,
                                           webSite: String?) -> UserProfileModel {
        UserProfileModel(name: name ?? userProfile.name,
                         avatar: avatar ?? userProfile.avatar,
                         description: description ?? userProfile.description,
                         webSite: webSite ?? userProfile.webSite)
    }
}
