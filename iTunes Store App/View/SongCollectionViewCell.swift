//
//  SongCollectionViewCell.swift
//  iTunes Store App
//
//  Created by Nicky Y on 2024/12/2.
//

import UIKit
import Kingfisher

class SongCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "SongCollectionViewCell"

    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    private let artistAlbumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [songNameLabel, artistAlbumLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        return stackView
    }()

    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit

        let heartImage = UIImage(systemName: "heart")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        button.setImage(heartImage, for: .normal)

        let heartFillImage = UIImage(systemName: "heart.fill")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        button.setImage(heartFillImage, for: .selected)

        return button
    }()

    private var likeAction: (() -> Void)?

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupLikeButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func setupLayout() {
        contentView.addSubview(albumImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(likeButton)

        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            albumImageView.widthAnchor.constraint(equalToConstant: 60),
            albumImageView.heightAnchor.constraint(equalToConstant: 60),

            likeButton.widthAnchor.constraint(equalToConstant: 20),
            likeButton.heightAnchor.constraint(equalToConstant: 20),
            likeButton.centerYAnchor.constraint(equalTo: albumImageView.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            stackView.centerYAnchor.constraint(equalTo: albumImageView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -16)
        ])
    }

    private func setupLikeButton() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }

    @objc private func likeButtonTapped() {
        likeButton.isSelected.toggle()
        likeAction?()
    }

    func configure(with song: Song, index: Int, isLiked: Bool) {
        albumImageView.kf.setImage(with: URL(string: song.artworkUrl100))
        songNameLabel.text = "\(index + 1). \(song.trackName)"
        artistAlbumLabel.text = "\(song.artistName) - \(song.collectionName)"
        likeButton.isSelected = isLiked
    }

    func pressLikeAction(_ action: @escaping () -> Void) {
        likeAction = action
    }
}
