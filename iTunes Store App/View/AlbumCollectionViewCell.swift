//
//  AlbumCollectionViewCell.swift
//  iTunes Store App
//
//  Created by Nicky Y on 2024/12/2.
//

import UIKit
import Kingfisher

class AlbumCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "AlbumCollectionViewCell"

    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let collectionNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [collectionNameLabel, artistNameLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4

        contentView.addSubview(albumImageView)
        contentView.addSubview(stackView)

        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            albumImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            albumImageView.widthAnchor.constraint(equalToConstant: 100),
            albumImageView.heightAnchor.constraint(equalToConstant: 100),

            stackView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: albumImageView.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: -4),
        ])
    }

    func configure(with album: Album, index: Int) {
        albumImageView.kf.setImage(with: URL(string: album.artworkUrl100))
        collectionNameLabel.text = "\(index + 1). \(album.collectionName)"
        artistNameLabel.text = album.artistName
    }
}
