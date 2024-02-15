//
//  MainViewController.swift
//  Spotify
//
//  Created by Aneli  on 15.02.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    var viewModel: MainViewModel?
    
    private lazy var recommendedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
        tableView.register(RecommendedMusicTableViewCell.self, forCellReuseIdentifier: "RecommendedMusicTableViewCell")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewsModel()
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        title = "Home"
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(recommendedTableView)
        recommendedTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
    private func setupViewsModel() {
        viewModel = MainViewModel()
        viewModel?.loadRecommendedMusic(completion: {
            self.recommendedTableView.reloadData()
        })
        }
    }
                

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfCells ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recommendedTableView.dequeueReusableCell(withIdentifier: "RecommendedMusicTableViewCell", for: indexPath) as! RecommendedMusicTableViewCell
        let data = viewModel?.getCellViewModel(at: indexPath)
        cell.configure(data: data)
        return cell
    }
}
