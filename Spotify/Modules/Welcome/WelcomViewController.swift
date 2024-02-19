//
//  WelcomViewController.swift
//  Spotify
//
//  Created by Aneli  on 17.02.2024.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - Properties
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        title = "Spotify"
        view.backgroundColor = .systemGreen
        
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }
    
    @objc
    private func didTapSignIn() {
        let controller = AuthViewController()
        controller.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(controller, animated: true)
    }
}
