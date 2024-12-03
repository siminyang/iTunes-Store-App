//
//  SongTableViewCell.swift
//  iTunes Store App
//
//  Created by Nicky Y on 2024/12/2.
//

import UIKit
import Kingfisher

class SongTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "SongTableViewCell"

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
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
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()

    private let artistAlbumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLikeButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func setupUI() {
        contentView.backgroundColor = .black
        contentView.addSubview(numberLabel)
        contentView.addSubview(albumImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(likeButton)

        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            albumImageView.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 16),
            albumImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            albumImageView.widthAnchor.constraint(equalToConstant: 60),
            albumImageView.heightAnchor.constraint(equalToConstant: 60),

            stackView.leadingAnchor.constraint(equalTo: albumImageView.trailingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: likeButton.leadingAnchor, constant: -16),

            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupLikeButton() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }

    @objc private func likeButtonTapped() {
        likeButton.isSelected.toggle()
        likeAction?()
    }

    func configure(with song: Song, index: Int, isLiked: Bool, likeAction: @escaping () -> Void) {
        numberLabel.text = "\(index + 1)"
        albumImageView.kf.setImage(with: URL(string: song.artworkUrl100))
        songNameLabel.text = song.trackName
        artistAlbumLabel.text = "\(song.artistName) - \(song.collectionName)"
        likeButton.isSelected = isLiked

        self.likeAction = likeAction
    }
}
