//
//  ViewController.swift
//  Wordle
//
//  Created by Kishan Patel on 4/27/23.
//

import UIKit

class ViewController: UIViewController {
    
    let keyboardVC = KeyboardViewController()
    let gridVC = GridViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addChildren()
    }
    
    private func addChildren() {
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
        
        addChild(gridVC)
        gridVC.didMove(toParent: self)
        gridVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridVC.view)
        
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            gridVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gridVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gridVC.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            gridVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }


}
