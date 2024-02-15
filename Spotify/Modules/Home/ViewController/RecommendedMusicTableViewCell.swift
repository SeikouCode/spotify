//
//  RecommendedMusicTableViewCell.swift
//  Spotify
//
//  Created by Aneli  on 15.02.2024.
//

import UIKit

class RecommendedMusicTableViewCell: UITableViewCell {
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
        return image
    }()
    
    private let textsStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = Consraints.textsStackViewSpacing
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.axis = .vertical
        return stack
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let rightView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "icon_right")
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: RecommendedMusicData?) {
        guard let data else { return }
        self.musicImage.image = data.image
        self.titleLabel.text = data.title
        if let subTitle = data.subTitle {
            self.subTitleLabel.text = subTitle
        } else {
            subTitleLabel.isHidden = true
        }
    }
    
    private func setupViews() {
        contentView.backgroundColor = .black
        selectionStyle = .none
        
        [titleLabel, subTitleLabel].forEach {
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
        }
        
        rightView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(Consraints.rightViewSize)
        }
    }
}
