import UIKit

final class UserNFTViewController: UIViewController {
    private let nftList: [String]
    private let viewModel: UserNFTViewModelProtocol
    
    private lazy var alertService: AlertServiceProtocol = {
        return AlertService(viewController: self)
    }()
    
    private lazy var nftTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NFTCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "sortButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var noNFTLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("noNFTTitle", comment: "")
        label.font = UIFont.sfBold17
        label.isHidden = true
        return label
    }()
    
    init(nftList: [String], viewModel: UserNFTViewModelProtocol) {
        self.nftList = nftList
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad(nftList: self.nftList)
        setupViews()
        configNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    @objc
    private func sortButtonTapped() {
        let priceAction = AlertActionModel(title: SortOption.price.description, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.userSelectedSorting(by: .price)
        }
        
        let ratingAction = AlertActionModel(title: SortOption.rating.description, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.userSelectedSorting(by: .rating)
        }
        
        let titleAction = AlertActionModel(title: SortOption.title.description, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.userSelectedSorting(by: .title)
        }
        
        let cancelAction = AlertActionModel(title: NSLocalizedString("closeTitle", comment: ""), style: .cancel, handler: nil)
        
        let alertModel = AlertModel(title: NSLocalizedString("sortTitle", comment: ""),
                                    message: nil,
                                    style: .actionSheet,
                                    actions: [priceAction, ratingAction, titleAction, cancelAction],
                                    textFieldPlaceholder: nil)
        
        alertService.showAlert(model: alertModel)
    }
    
    
    
    private func sortData(by option: SortOption) {
        viewModel.userSelectedSorting(by: option)
    }
    
    private func bind() {
        viewModel.observeUserNFT { [weak self] _ in
            guard let self = self else { return }
            self.nftTableView.reloadData()
        }
        
        viewModel.observeState { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                self.setUIInteraction(false)
            case .loaded(let hasData):
                if hasData {
                    self.updateUIBasedOnNFTData()
                } else {
                    self.noNFTLabel.isHidden = false
                }
            case .error(_):
                print("Ошибка")
                // ToDo: - Error Alert
            default:
                break
            }
        }
    }
    
    private func updateUIBasedOnNFTData() {
        let barButtonItem = UIBarButtonItem(customView: sortButton)
        navigationItem.rightBarButtonItem = barButtonItem
        navigationItem.title = NSLocalizedString("MyNFTTitle", comment: "")
        setUIInteraction(true)
    }
    
    private func setUIInteraction(_ enabled: Bool) {
        DispatchQueue.main.async {
            self.navigationItem.leftBarButtonItem?.isEnabled = enabled
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        [nftTableView, noNFTLabel].forEach { view.addViewWithNoTAMIC($0) }
        
        NSLayoutConstraint.activate([
            nftTableView .topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nftTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            noNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configNavigationBar() {
        setupCustomBackButton()
    }
}

// MARK: - UITableViewDataSource

extension UserNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.userNFT?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NFTCell = tableView.dequeueReusableCell()
        cell.selectionStyle = .none
        
        guard let nft = viewModel.userNFT?[indexPath.row] else {
            print("Error to get NFT")
            return cell
        }
        
        if let author = viewModel.authors[nft.author] {
            cell.configure(nft: nft, authorName: author.name)
        } else {
            print("error to get author ID")
            cell.configure(nft: nft, authorName: "Unknown author")
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension UserNFTViewController: UITableViewDelegate {
    
}
