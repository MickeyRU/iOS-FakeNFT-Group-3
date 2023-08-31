import UIKit

final class CatalogViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupNavigationItem()
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
}
