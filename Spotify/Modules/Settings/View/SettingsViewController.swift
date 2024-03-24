//
//  SettingsViewController.swift
//  Spotify
//
//  Created by Aneli  on 02.03.2024.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    private var sections = [Section]()
    private var currentLanguage: SupportedLanguages? {
        didSet {
            guard let currentLanguage else { return }
            didChange(language: currentLanguage)
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupData()
    }
    
    override func setupTitles() {
        title = "Settings".localized
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "icon_language"),
            style: .done,
            target: self,
            action: #selector(didTapLanguage)
        )
    }
    
    @objc
    private func didTapLanguage() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        SupportedLanguages.all.forEach { language in
            alert.addAction(
                .init(
                    title: language.localizedTitle,
                    style: .default,
                    handler: { [weak self] _ in
                        self?.currentLanguage = language
                    }
                )
            )
        }
        
        alert.addAction(.init(title: "Cancel".localized, style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func didChange(language: SupportedLanguages) {
        Bundle.setLanguage(language: language.rawValue)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("language"), object: nil)
        }
    }
    
    private func setupViews() {
        title = "Settings".localized
        view.backgroundColor = .black
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupData() {
        sections.append(
            .init(
                title: "Profile".localized,
                rows: [
                    .init(
                        title: "View_Your_Profile".localized,
                        handler: { [weak self] in
                            DispatchQueue.main.async {
                                self?.showProfilePage()
                            }
                        })
                ]
            )
        )
        
        sections.append(
            .init(
                title: "Account".localized,
                rows: [
                    .init(
                        title: "Sign_Out".localized,
                        handler: { [weak self] in
                            DispatchQueue.main.async {
                                self?.didTapSignOut()
                            }
                        })
                ]
            )
        )
    }
    
    private func showProfilePage() {
        let controller = ProfileViewController()
        controller.title = "Profile".localized
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func didTapSignOut() {
        let alert = UIAlertController(title: "Sign Out", message: "Do you really want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { success in
                if success {
                    DispatchQueue.main.async {
                        let welcomeViewController = WelcomeViewController()
                        let navigationController = UINavigationController(rootViewController: welcomeViewController)
                        navigationController.navigationBar.prefersLargeTitles = true
                        navigationController.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            if let window = windowScene.windows.first {
                                window.rootViewController = navigationController
                                window.makeKeyAndVisible()
                            }
                        }
                    }
                } else {
                    print("Error signing out")
                }
            }
        }))
        present(alert, animated: true)
    }
}
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let model = sections[indexPath.section].rows[indexPath.row]
        cell.textLabel?.text = model.title
        cell.backgroundColor = .gray
        cell.textLabel?.textColor = .black
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sections[indexPath.section].rows[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let modelTitle = sections[section].title
        return modelTitle
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        
        if section == 0 {
            headerView.textLabel?.textColor = .white
        } else if section == 1 {
            headerView.textLabel?.textColor = .white
        }
    }
}
