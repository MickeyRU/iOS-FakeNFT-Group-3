import UIKit

final class ProfileViewController: UIViewController {
    private lazy var imageButton: UIButton = {
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
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Joaquin Phoenix"
        label.font = UIFont.sfBold22
        return label
    }()
    
    private let userDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.sfRegular13
        label.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
        label.numberOfLines = 0
        return label
    }()
    
    private let urlTextView: UITextView = {
        let textView = UITextView()
        let text = "Joaquin Phoenix.com"
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
    
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.delegate = self

        setupViews()
    }
    
    @objc
    private func editButtonTapped() {
        print("editButtonTapped")
        // ToDo: действия по нажатию на кнопку редактирование
    }
    
    private func setupViews() {
        [imageButton, profileImageView, userNameLabel, userDescriptionLabel, urlTextView, profileTableView].forEach { view.addViewWithNoTAMIC($0) }
        
        NSLayoutConstraint.activate([
            imageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            imageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            imageButton.heightAnchor.constraint(equalToConstant: 42),
            imageButton.widthAnchor.constraint(equalTo: imageButton.heightAnchor, multiplier: 1.0),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 20),
            
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            userDescriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            userDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userDescriptionLabel.trailingAnchor.constraint(equalTo: imageButton.leadingAnchor),
            userDescriptionLabel.heightAnchor.constraint(equalToConstant: 72),
            
            urlTextView.topAnchor.constraint(equalTo: userDescriptionLabel.bottomAnchor, constant: 8),
            urlTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            urlTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            urlTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 72),
            
            profileTableView.topAnchor.constraint(equalTo: urlTextView.bottomAnchor, constant: 40),
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
            destinationVC = UserNFTViewController()
        case 2:
            destinationVC = UserNFTViewController()
        default:
            break
        }
        destinationVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}


extension ProfileViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is ProfileViewController {
            navigationController.setNavigationBarHidden(true, animated: animated)
        } else if viewController is UserNFTViewController || viewController is UserNFTViewController || viewController is UserNFTViewController {
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
    }
}
