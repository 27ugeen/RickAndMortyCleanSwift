//
//  CharacterTableViewCell.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import UIKit

final class CharacterTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CharacterCell"
    
    private enum UIConstants {
        static let imageSize: CGFloat = 50
        static let imageCornerRadius: CGFloat = 25
        static let padding: CGFloat = 8
        static let spacing: CGFloat = 16
    }
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = UIConstants.imageCornerRadius
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        activityIndicator.stopAnimating()
    }
    
    private func setupUI() {
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.padding),
            characterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: UIConstants.imageSize),
            characterImageView.heightAnchor.constraint(equalToConstant: UIConstants.imageSize),
            
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: UIConstants.spacing),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIConstants.padding),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: characterImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor),
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: characterImageView.bottomAnchor, constant: UIConstants.padding)
        ])
    }
    
    func configure(with character: CharactersListModels.CharacterViewModel) {
        nameLabel.text = character.name
        characterImageView.image = nil
        activityIndicator.startAnimating()

        if let cachedImage = ImageCacheManager.shared.loadImage(id: character.id) {
            characterImageView.image = cachedImage
            activityIndicator.stopAnimating()
        } else {
            ImageLoader.shared.loadImage(from: character.imageURL) { [weak self] image in
                DispatchQueue.main.async {
                    guard let self else { return }
                    self.activityIndicator.stopAnimating()
                    if let image {
                        ImageCacheManager.shared.saveImage(image, id: character.id)
                        self.characterImageView.image = image
                    }
                }
            }
        }
    }
}
