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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
    }
    
    @objc
    private func editButtonTapped() {
        print("editButtonTapped")
        // ToDo: действия по нажатию на кнопку редактирование
    }
    
    @objc
    private func linkTapped() {
        print("linkTapped")
        // ToDo: действия по нажатию на ссылку
    }
    
    private func setupViews() {
        [imageButton, profileImageView, userNameLabel, userDescriptionLabel, urlTextView].forEach { view.addViewWithNoTAMIC($0) }
        
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
            urlTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 72)
        ])
    }
}
