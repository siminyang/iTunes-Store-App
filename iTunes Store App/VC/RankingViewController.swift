//
//  RankingViewController.swift
//  iTunes Store App
//
//  Created by Nicky Y on 2024/12/2.
//

import UIKit
import Combine

enum RankingSection: Int, CaseIterable {
    case songs = 0
    case albums = 1
}

class RankingViewController: UIViewController {

    // MARK: - Properties
    private let viewModel = RankingViewModel()
    private var cancellables = Set<AnyCancellable>()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            return self?.createSectionLayout(for: section)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SongCollectionViewCell.self, forCellWithReuseIdentifier: SongCollectionViewCell.identifier)
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        return collectionView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var segmentControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["精選項目", "排行榜"])
        segmentedControl.selectedSegmentIndex = 1

        segmentedControl.backgroundColor = .darkGray.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentTintColor = .lightGray.withAlphaComponent(0.5)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)

        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return segmentedControl
    }()

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
    }

    // MARK: - Methods
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupNavigationBar() {
        navigationItem.titleView = segmentControl
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "音樂", style: .plain, target: nil, action: nil)

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
                self?.activityIndicator.stopAnimating()
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$albums
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.activityIndicator.stopAnimating()
                self?.collectionView.reloadData()
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

    private func createSectionLayout(for section: Int) -> NSCollectionLayoutSection {
        let isFirstSection = (section == 0)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1/4)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 10)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(isFirstSection ? view.bounds.width - 80 : 100),
            heightDimension: .absolute(isFirstSection ? 280 : 120)
        )
        let group = isFirstSection ?
            NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 4) :
            NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        let spacing: CGFloat = isFirstSection ? 0 : 10
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = isFirstSection ? .groupPaging : .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        section.interGroupSpacing = 16

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
}

// MARK: - CollectionViewDataSource, CollectionViewDelegate
extension RankingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return RankingSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = RankingSection(rawValue: section) else { return 0 }

        switch section {
        case .songs:
            return min(viewModel.songs.count, 36)
        case .albums:
            return min(viewModel.albums.count, 36)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let section = RankingSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }

        switch section {
        case .songs:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SongCollectionViewCell.identifier, for: indexPath) as? SongCollectionViewCell else {
                return UICollectionViewCell()
            }
            let song = viewModel.songs[indexPath.item]

            cell.configure(with: song, index: indexPath.item, isLiked: viewModel.isLiked(for: song))
            cell.pressLikeAction { [weak self] in
                self?.viewModel.toggleLike(for: song)
            }
            return cell

        case .albums:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else {
                return UICollectionViewCell()
            }
            let album = viewModel.albums[indexPath.item]

            cell.configure(with: album, index: indexPath.item)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView else { 
            return UICollectionReusableView()
        }
        guard let section = RankingSection(rawValue: indexPath.section) else {
            return UICollectionReusableView()
        }

        switch section {
        case .songs:
            headerView.configure(title: "歌曲")
            headerView.showAllAction = { [weak self] in
                if let detailViewModel = self?.viewModel.createDetailListViewModel() {
                    let detailVC = DetailListViewController(viewModel: detailViewModel, section: indexPath.section)
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        case .albums:
            headerView.configure(title: "專輯")
            headerView.showAllButton.isUserInteractionEnabled = false
        }

        return headerView
    }
}

// MARK: - DetailListViewControllerDelegate
extension RankingViewController: DetailListViewControllerDelegate {
    func detailListViewController(_ detailListViewController: DetailListViewController, didUpdateLikeStateFor song: Song) {
        if let index = viewModel.songs.firstIndex(where: { $0.trackId == song.trackId }) {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
