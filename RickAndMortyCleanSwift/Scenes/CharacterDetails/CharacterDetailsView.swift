//
//  CharacterDetailsView.swift
//  RickAndMortyCleanSwift
//
//  Created by GiN Eugene on 4/2/2025.
//

import UIKit

final class CharacterDetailsView: UIView {
    private enum UIConstants {
        static let horizontalPadding: CGFloat = 16
        static let topPadding: CGFloat = 16
        static let imageSize: CGFloat = 200
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func setupUI() {
        addSubview(nameLabel)
        addSubview(imageView)
        addSubview(detailsLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: UIConstants.topPadding),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.horizontalPadding),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIConstants.horizontalPadding),
            
            imageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: UIConstants.topPadding),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: UIConstants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: UIConstants.imageSize),
            
            detailsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: UIConstants.topPadding),
            detailsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.horizontalPadding),
            detailsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIConstants.horizontalPadding)
        ])
    }
    
    func configure(with viewModel: CharacterDetailsModels.ViewModel) {
        nameLabel.text = viewModel.name
        detailsLabel.text = viewModel.description
        
        ImageLoader.shared.loadImage(from: viewModel.imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
}
