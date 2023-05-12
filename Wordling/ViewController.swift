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
        label.text = "WORDLING"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 45.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        view.addSubview(label)
        let fourLetterBtn = createButton(letters: 4)
        let fiveLetterBtn = createButton(letters: 5)
        let sixLetterBtn = createButton(letters: 6)
        view.addSubview(fourLetterBtn)
        view.addSubview(fiveLetterBtn)
        view.addSubview(sixLetterBtn)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            
            fourLetterBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            fourLetterBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            fourLetterBtn.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 75),
            fourLetterBtn.heightAnchor.constraint(equalToConstant: 50.0),
            
            fiveLetterBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            fiveLetterBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            fiveLetterBtn.topAnchor.constraint(equalTo: fourLetterBtn.bottomAnchor, constant: 25),
            fiveLetterBtn.heightAnchor.constraint(equalToConstant: 50.0),
            
            sixLetterBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            sixLetterBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            sixLetterBtn.topAnchor.constraint(equalTo: fiveLetterBtn.bottomAnchor, constant: 25),
            sixLetterBtn.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    func createButton(letters: Int) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = createConfig(letters: letters)
        button.tag = letters
        button.addTarget(self, action: #selector(startBtnTapped(_:)), for: .touchUpInside)
        return button
    }
    
    func createConfig(letters: Int) -> UIButton.Configuration {
        var config: UIButton.Configuration = .filled()
        config.baseBackgroundColor = .systemTeal
        config.title = "\(letters) Letters"
        config.cornerStyle = .capsule
        return config
    }
    
    @objc func startBtnTapped(_ sender: UIButton) {
        let gameVC = GameViewController()
        gameVC.numOfLetters = sender.tag
        let navVC = UINavigationController(rootViewController: gameVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}
