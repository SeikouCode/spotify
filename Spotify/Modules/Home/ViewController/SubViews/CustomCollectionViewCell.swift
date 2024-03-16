//
//  CustomCollectionViewCell.swift
//  Spotify
//
//  Created by Aneli  on 06.03.2024.
//

import UIKit
import SkeletonView
import Kingfisher

class CustomCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Components
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isSkeletonable = true
        imageView.skeletonCornerRadius = 8
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PlayfairDisplay-Regular", size: 15)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 2
        label.isSkeletonable = true
        label.skeletonCornerRadius = 2
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
        titleLabel.text = nil
    }
    
    func configure(data: AlbumsData) {
        if let imageUrl = URL(string: data.image ?? "") {
            albumImageView.kf.setImage(with: imageUrl)
        } else {
            albumImageView.image = nil
        }
        titleLabel.text = data.title
    }
    
    private func setupViews() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        [albumImageView, titleLabel].forEach {
            contentView.addSubview($0)
        }
        
        albumImageView.snp.makeConstraints { make in
            make.size.equalTo(150)
            make.top.left.right.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(albumImageView.snp.bottom).offset(8)
            make.left.bottom.right.equalToSuperview().inset(8)
            make.height.greaterThanOrEqualTo(35)
            make.width.greaterThanOrEqualTo(150)
        }
    }
}

