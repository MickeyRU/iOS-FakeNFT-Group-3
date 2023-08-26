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
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 35
        return imageView
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
    
    private func setupViews() {
        [imageButton, profileImageView].forEach { view.addViewWithNoTAMIC($0) }
        
        NSLayoutConstraint.activate([
            imageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            imageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            imageButton.heightAnchor.constraint(equalToConstant: 42),
            imageButton.widthAnchor.constraint(equalTo: imageButton.heightAnchor, multiplier: 1.0),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 20)
        ])
    }
}
