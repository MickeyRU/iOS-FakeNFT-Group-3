import UIKit

final class CatalogViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.identifier)
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()

    private let collections = [
        NFTCollection(
            id: "1",
            name: "Peach",
            imageString: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Peach.png",
            nfts: ["1", "2", "3"],
            author: "Author",
            description: "Some description of collection"),
        NFTCollection(id: "2",
            name: "Blue",
            imageString: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Blue.png",
            nfts: ["1", "2" ],
            author: "Author",
            description: "Some description of collection"),
        NFTCollection(
            id: "3",
            name: "Brown",
            imageString: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png",
            nfts: ["1", "2", "3", "4"],
            author: "Author", description: "Some description of collection"
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupNavigationItem()
        setupView()
        setupConstraints()

        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc
    private func sortButtonTapped() {
        let alert = UIAlertController(
            title: NSLocalizedString("sort", comment: "Sorting alert title"),
            message: nil,
            preferredStyle: .actionSheet)

        let sortByName = UIAlertAction(
            title: NSLocalizedString("sort.byName", comment: "Sorting alert by name button"),
            style: .default) { _ in
            print("Sorted by name")

        }
        alert.addAction(sortByName)

        let sortByCount = UIAlertAction(
            title: NSLocalizedString("sort.byAmount", comment: "Sorting alert by amount button"),
            style: .default) { _ in
            print("Sorted by count")
        }
        alert.addAction(sortByCount)

        let cancel = UIAlertAction(
            title: NSLocalizedString("close", comment: "Sorting alert close button"),
            style: .cancel)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.identifier) as? CatalogCell else {
            return UITableViewCell()
        }

        let collection = collections[indexPath.row]
        cell.config(with: collection)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }

}

// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Collection was selected")
    }
}

// MARK: - UI
extension CatalogViewController {
    func setupNavigationItem() {
        let barItem = UIBarButtonItem(
            image: UIImage(named: "sort"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped))
        barItem.tintColor = .unBlack
        navigationItem.rightBarButtonItem = barItem
    }

    func setupView() {
        view.addViewWithNoTAMIC(tableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
