import UIKit
import Kingfisher
import ProgressHUD

final class EditingViewController: UIViewController {
    private let viewModel: EditingViewModelProtocol
    
    private let userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexString: "1A1B22").withAlphaComponent(0.6)
        view.layer.cornerRadius = 35
        return view
    }()
    
    private lazy var alertService: ProfileAlertServiceProtocol = {
        return ProfileAlertService(viewController: self)
    }()
    
    private lazy var nameLabel = ViewFactory.shared.createTextLabel()
    private lazy var nameTextView = ViewFactory.shared.createTextView()
    private lazy var descriptionLabel = ViewFactory.shared.createTextLabel()
    private lazy var descriptionTextView = ViewFactory.shared.createTextView()
    private lazy var webSiteLabel = ViewFactory.shared.createTextLabel()
    private lazy var webSiteTextView = ViewFactory.shared.createTextView()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "xmarkImage"), for: .normal)
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
        button.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: EditingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        
        setupViews()
        setupDelegates()
    }
    
    @objc
    private func exitButtonTapped() {
        viewModel.exitButtonTapped()
        dismiss(animated: true)
    }
    
    @objc
    private func changePhotoTapped() {
        let confirmAction = AlertActionModel(title: "Подтвердить", style: .default) { [weak self] urlText in
            guard let self = self else { return }
            if let urlText = urlText,
               let url = URL(string: urlText) {
                self.viewModel.photoURLdidChanged(with: url)
            } else {
                let errorModel = AlertModel(title: "Ошибка",
                                            message: "Введен не корректный URL адрес",
                                            style: .alert,
                                            actions: [AlertActionModel(title: "OK", style: .cancel, handler: nil)],
                                            textFieldPlaceholder: nil)
                alertService.showAlert(model: errorModel)
            }
        }
        
        let cancelAction = AlertActionModel(title: "Отмена", style: .cancel, handler: nil)
        
        let alertModel = AlertModel(title: "Введите URL", message: nil, style: .alert, actions: [confirmAction, cancelAction], textFieldPlaceholder: "URL изображения")
        
        alertService.showAlert(model: alertModel)
    }
    
    
    private func bind() {
        viewModel.observeUserProfileChanges { [weak self] (profile: UserProfile?) in
            guard
                let self = self,
                let profile = profile
            else { return }
            self.updateUIElements(with: profile)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .unWhite
        view.addTapGestureToHideKeyboard()
        
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
        [nameTextView, descriptionTextView, webSiteTextView].forEach { $0.delegate = self }
    }
    
    private func updateUIElements(with profile: UserProfile) {
        DispatchQueue.main.async {
            self.userPhotoImageView.kf.setImage(with: URL(string: profile.avatar))
            self.nameLabel.text = NSLocalizedString("userName", comment: "")
            self.nameTextView.text = profile.name
            self.descriptionLabel.text = NSLocalizedString("discription", comment: "")
            self.descriptionTextView.text = profile.description
            self.webSiteLabel.text = NSLocalizedString("webSite", comment: "")
            self.webSiteTextView.text = profile.website
        }
        ProgressHUD.dismiss()
    }
}

// MARK: - UITextViewDelegate

extension EditingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            switch textView {
            case nameTextView:
                viewModel.updateName(text)
            case descriptionTextView:
                viewModel.updateDescription(text)
            case webSiteTextView:
                viewModel.updateWebSite(text)
            default:
                break
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
