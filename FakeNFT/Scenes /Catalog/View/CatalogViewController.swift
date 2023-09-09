import UIKit

final class CatalogViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.identifier)
        // tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()

    private let viewModel: CatalogViewModelProtocol

    init(viewModel: CatalogViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupNavigationItem()
        setupView()
        setupConstraints()

        tableView.dataSource = self
        tableView.delegate = self

        bind()
        viewModel.initialize()
    }

    private func bind() {
        viewModel.collectionsObserve.bind(action: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
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
        return viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.identifier) as? CatalogCell,
            let collection = viewModel.collection(at: indexPath) else {
            return UITableViewCell()
        }

        cell.viewModel = viewModel.getCellViewModel(for: collection)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }

}

// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let collection = viewModel.collection(at: indexPath) else {
            return
        }

        let vc = UINavigationController(
            rootViewController: NFTCollectionViewController(
                with: collection,
                viewModel: NFTCollectionViewModel()))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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
