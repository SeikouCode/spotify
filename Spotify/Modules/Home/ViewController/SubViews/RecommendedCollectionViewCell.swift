//
//  RecommendedCollectionViewCell.swift
//  Spotify
//
//  Created by Aneli  on 06.03.2024.
//

import UIKit
import SkeletonView

class RecommendedCollectionViewCell: UICollectionViewCell {
    private enum Consraints {
        static let musicImageSize: CGFloat = 48
        static let musicImageCornerRadius: CGFloat = 24
        static let textsStackViewSpacing: CGFloat = 2
        static let rightViewSize: CGFloat = 24
    }
    
    private let musicImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = Consraints.musicImageCornerRadius
        image.contentMode = .scaleAspectFill
        image.isSkeletonable = true
        image.skeletonCornerRadius = 24
        return image
    }()

    private let textsStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = Consraints.textsStackViewSpacing
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.axis = .vertical
        stack.isSkeletonable = true
        return stack
    }()
    
    private var titleLabel = LabelFactory.createLabel(
        font: UIFont(name: "Lato-Regular", size: 16),
        isSkeletonable: true
    )
    
    private var subtitleLabel = LabelFactory.createLabel(
        font: UIFont(name: "Lato-Regular", size: 13),
        isSkeletonable: true
    )
    
    private let rightView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "icon_right")
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: RecommendedMusicData?) {
        guard let data = data else { return }
        self.musicImage.image = data.image
        self.titleLabel.text = data.title
        self.subtitleLabel.text = data.subtitle
    }
    
    private func setupViews() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        contentView.backgroundColor = .black
        
        [titleLabel, subtitleLabel].forEach {
            textsStackView.addArrangedSubview($0)
        }
        
        [musicImage, textsStackView, rightView].forEach {
            contentView.addSubview($0)
        }

        musicImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(8)
            make.size.equalTo(Consraints.musicImageSize)
        }
        
        textsStackView.snp.makeConstraints { make in
            make.left.equalTo(musicImage.snp.right).offset(12)
            make.top.bottom.equalTo(musicImage)
            make.height.greaterThanOrEqualTo(35)
            make.width.greaterThanOrEqualTo(150)
        }
        
        rightView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(Consraints.rightViewSize)
        }
    }
}
