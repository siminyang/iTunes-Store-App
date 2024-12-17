//
//  SectionHeaderView.swift
//  iTunes Store App
//
//  Created by Nicky Y on 2024/12/2.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    // MARK: - Properties
    static let identifier = "SectionHeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    lazy var showAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("顯示全部 >", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        return button
    }()

    var showAllAction: (() -> Void)?

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupshowAllButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(showAllButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        showAllButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            showAllButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            showAllButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupshowAllButton() {
        showAllButton.addTarget(self, action: #selector(showAllTapped), for: .touchUpInside)
    }

    @objc private func showAllTapped(_ sender: UIButton) {
        showAllAction?()
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
