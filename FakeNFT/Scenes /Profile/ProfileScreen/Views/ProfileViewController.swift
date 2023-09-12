import UIKit
import Kingfisher
import ProgressHUD

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
        textView.isHidden = true
        return textView
    }()
    
    private let viewModel: ProfileViewModelProtocol
    private lazy var router = ProfileRouter(viewController: self)
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "editButton"), for: .normal)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileCell.self)
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
        viewModel.viewDidLoad()
        
        self.navigationController?.delegate = self
        self.tabBarController?.tabBar.isHidden = true

        setupViews()
    }

    @objc
    private func editButtonTapped() {
        router.routeToEditingViewController()
    }
    
    private func bind() {
        viewModel.observeUserProfileChanges { [weak self] profileModel in
            guard
                let self = self,
                let model = profileModel
            else { return }
            self.updateUI(with: model)
        }
    }
    
    private func updateUI(with model: UserProfile) {
        DispatchQueue.main.async {
            self.profileImageView.kf.setImage(with: URL(string: model.avatar)) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.userNameLabel.text = model.name
                        self.userDescriptionLabel.text = model.description
                        self.userWebSiteTextView.text = model.website
                        [self.editButton, self.profileImageView, self.userNameLabel, self.userDescriptionLabel, self.userWebSiteTextView, self.profileTableView].forEach { $0.isHidden = false }
                        self.tabBarController?.tabBar.isHidden = false
                        self.profileTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                    // ToDo: Аллерт для пользователя
                }
            }
            ProgressHUD.dismiss()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        [editButton, profileImageView, userNameLabel, userDescriptionLabel, userWebSiteTextView, profileTableView].forEach {
            view.addViewWithNoTAMIC($0)
            $0.isHidden = true
        }
        
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
            
            userWebSiteTextView.topAnchor.constraint(equalTo: userDescriptionLabel.bottomAnchor, constant: 8),
            userWebSiteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userWebSiteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
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
        let cell: ProfileCell = tableView.dequeueReusableCell()
        var cellTitle = ""
        switch indexPath.row {
        case 0:
            cellTitle = NSLocalizedString("MyNFTTitle", comment: "") + " (\(viewModel.userProfile?.nfts.count ?? 0))"
        case 1:
            cellTitle = "Избранные NFT " + "(\(viewModel.userProfile?.likes.count ?? 0))"
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
        switch indexPath.row {
        case 0:
            router.routeToUserNFT(nftList: viewModel.userProfile?.nfts ?? [])
        case 1:
            router.routeToFavoritesNFT(nftList: viewModel.userProfile?.likes ?? [])
        case 2:
            if let url = URL(string: userWebSiteTextView.text) {
                router.routeToWebView(url: url)
            }
        default:
            break
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is ProfileViewController {
            navigationController.setNavigationBarHidden(true, animated: animated)
        } else if viewController is UserNFTViewController || viewController is FavoritesNFTViewController || viewController is WebViewViewController {
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
    }
}
