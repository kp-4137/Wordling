//
//  ViewController.swift
//  Wordle
//
//  Created by Kishan Patel on 4/27/23.
//

import UIKit

class ViewController: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "WORDLE"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 35.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        view.addSubview(label)
        let startBtn = createButton()
        view.addSubview(startBtn)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 375),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -375),
            
            startBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            startBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            startBtn.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 75),
            startBtn.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    func createButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = createConfig()
        button.addTarget(self, action: #selector(startBtnTapped), for: .touchUpInside)
        return button
    }
    
    func createConfig() -> UIButton.Configuration {
        var config: UIButton.Configuration = .filled()
        config.baseBackgroundColor = .systemTeal
        config.title = "Start Game"
        config.cornerStyle = .capsule
        return config
    }
    
    @objc func startBtnTapped() {
        let gameVC = GameViewController()
        let navVC = UINavigationController(rootViewController: gameVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}
