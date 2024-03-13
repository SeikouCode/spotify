//
//  HeaderView.swift
//  Spotify
//
//  Created by Aneli  on 11.03.2024.
//

import UIKit

class HeaderView: UICollectionReusableView {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PlayfairDisplay-Regular", size: 15)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        titleLabel.text = text
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(2)
        }
    }
}
