//
//  AlbumDetailsViewController.swift
//  Spotify
//
//  Created by Aneli  on 24.03.2024.
//

import UIKit

class AlbumDetailsViewController: BaseViewController {

    var albumId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Album Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGradient()
    }
    
    private func setupGradient() {
        let firstColor = UIColor(
            red: 0.0/255.0,
            green: 128.0/255.0,
            blue: 174.0/255.0,
            alpha: 1
        ).cgColor
        
        let secondColor = UIColor.black.cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [firstColor, secondColor]
        gradient.locations = [0.0, 0.4]
        gradient.type = .axial
        gradient.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
}
