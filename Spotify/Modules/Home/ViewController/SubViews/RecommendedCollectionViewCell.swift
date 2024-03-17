//
//  RecommendedCollectionViewCell.swift
//  Spotify
//
//  Created by Aneli  on 06.03.2024.
//

import UIKit
import SkeletonView
import Kingfisher

class RecommendedCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let musicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.isSkeletonable = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Regular", size: 16)
        label.textColor = .white
        label.numberOfLines = 2
        label.isSkeletonable = true
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Regular", size: 13)
        label.textColor = .white
        label.isSkeletonable = true
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
        musicImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    func configure(data: RecommendedMusicData) {
        if let imageUrl = URL(string: data.image ?? "") {
            musicImageView.kf.setImage(with: imageUrl)
        } else {
            musicImageView.image = nil
        }
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
    }
    
    private func setupViews() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        [musicImageView, titleLabel, subtitleLabel].forEach {
            contentView.addSubview($0)
        }
        
        musicImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(8)
            make.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(musicImageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.right.bottom.equalToSuperview().inset(8)
        }
    }
}

