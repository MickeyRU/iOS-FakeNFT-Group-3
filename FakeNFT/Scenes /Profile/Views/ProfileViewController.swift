import UIKit

final class ProfileViewController: UIViewController {
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfBold22
        return label
    }()
    
    private let userDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfRegular13
        label.numberOfLines = 0
        return label
    }()
    
    private let userWebSiteTextView: UITextView = {
        let textView = UITextView()
        let text = ""
        let attributedString = NSMutableAttributedString(string: text)
        let linkRange = NSRange(location: 0, length: text.count)
        attributedString.addAttribute(.link, value: text, range: linkRange)
        
        textView.attributedText = attributedString
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        textView.font = UIFont.sfRegular15
        textView.textContainer.lineFragmentPadding = 16
        return textView
    }()
    
    private var viewModel: ProfileViewModelProtocol

    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "editButton"), for: .normal)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mockAvatar")
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.delegate = self
        
        viewModel.getUserProfileData()
        
        setupViews()
    }
    
    @objc
    private func editButtonTapped() {
        guard let userProfile = viewModel.userProfile else { return }
        let editingViewController = EditingViewController(userProfile: userProfile, delegate: self)
        present(editingViewController, animated: true)
    }
    
    private func bind() {
        viewModel.observeUserProfileChanges { [weak self] (profileModel: UserProfileModel?) in
          guard
            let self = self,
            let profileModel = profileModel
            else { return }
            self.userNameLabel.text = profileModel.name
            self.userDescriptionLabel.text = profileModel.description
            self.userWebSiteTextView.text = profileModel.webSite
            // ToDo: - логика загрузки картинок по URl, количества NFT, избранных NFT
        }
    }
    
    private func setupViews() {
        [editButton, profileImageView, userNameLabel, userDescriptionLabel, userWebSiteTextView, profileTableView].forEach { view.addViewWithNoTAMIC($0) }
        
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            editButton.heightAnchor.constraint(equalToConstant: 42),
            editButton.widthAnchor.constraint(equalTo: editButton.heightAnchor, multiplier: 1.0),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            userDescriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            userDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userDescriptionLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor),
            userDescriptionLabel.heightAnchor.constraint(equalToConstant: 72),
            
            userWebSiteTextView.topAnchor.constraint(equalTo: userDescriptionLabel.bottomAnchor, constant: 8),
            userWebSiteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userWebSiteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userWebSiteTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 72),
            
            profileTableView.topAnchor.constraint(equalTo: userWebSiteTextView.bottomAnchor, constant: 40),
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.heightAnchor.constraint(equalToConstant: 162)
        ])
    }
}

//MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as? ProfileCell else { return UITableViewCell() }
        var cellTitle = ""
        // ToDo: -  Доработать интерполяцию строк в 0 и 1 кейсах, после внедрения логики работы с сетью
        switch indexPath.row {
        case 0:
            cellTitle = "Мои NFT" + " (112)"
        case 1:
            cellTitle = "Избранные NFT" + " (11)"
        case 2:
            cellTitle = "О разработчике"
        default:
            break
        }
        
        cell.configure(title: cellTitle)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
}

//MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var destinationVC = UIViewController()
        switch indexPath.row {
        case 0:
            destinationVC = UserNFTViewController()
        case 1:
            destinationVC = FavoritesNFTViewController()
        case 2:
            guard let url = URL(string: userWebSiteTextView.text) else { break }
            destinationVC = WebViewViewController(url: url)
            // ToDo: - индикатор загрузки
        default:
            break
        }
        destinationVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - UINavigationControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is ProfileViewController {
            navigationController.setNavigationBarHidden(true, animated: animated)
        } else if viewController is UserNFTViewController || viewController is FavoritesNFTViewController || viewController is WebViewViewController {
            navigationController.setNavigationBarHidden(false, animated: animated)
            
            let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backItem
        }
    }
}

// MARK: - EditingViewControllerProtocol

extension ProfileViewController: EditingViewControllerProtocol {
    func updateUserProfile(userProfile: UserProfileModel) {
        print(userProfile.name)
        
        viewModel.updateUserProfileData(profile: userProfile)
    }
}
