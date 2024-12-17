//
//  DetailListViewController.swift
//  iTunes Store App
//
//  Created by Nicky Y on 2024/12/2.
//

import Combine
import UIKit

protocol DetailListViewControllerDelegate: AnyObject {
    func detailListViewController(_ detailListViewController: DetailListViewController, didUpdateLikeStateFor song: Song)
}

class DetailListViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: DetailListViewModel
    private let section: Int
    private var cancellables = Set<AnyCancellable>()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: SongTableViewCell.identifier)
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    weak var delegate: DetailListViewControllerDelegate?

    // MARK: - Lifecycle
    init(viewModel: DetailListViewModel, section: Int) {
        self.viewModel = viewModel
        self.section = section
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        setupNavigationBar()
        bindViewModel()
        loadMoreData()
    }

    // MARK: - Methods
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        tableView.frame = view.bounds
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func setupNavigationBar() {
        navigationItem.title = "歌曲"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = true
    }

    private func bindViewModel() {
        viewModel.$songs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }

    private func loadMoreData() {
        guard !viewModel.isLoading else { return }

        viewModel.loadMoreSongs()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to load more songs: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] newSongs in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - TableViewDataSource, TableViewDelegate
extension DetailListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath) as? SongTableViewCell else {
            return UITableViewCell()
        }
        let song = viewModel.songs[indexPath.row]

        cell.configure(with: song, index: indexPath.row, isLiked: viewModel.isLiked(for: song))
        cell.pressLikeAction { [weak self] in
            guard let self = self else { return }
            self.viewModel.toggleLike(for: song)
            self.delegate?.detailListViewController(self, didUpdateLikeStateFor: song)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == viewModel.songs.count - 10 && !viewModel.isLoading && viewModel.hasMoreData {
            loadMoreData()
        }
    }
}
