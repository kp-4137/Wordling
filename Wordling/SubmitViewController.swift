//
//  SubmitViewController.swift
//  Wordling
//
//  Created by Kishan Patel on 5/3/23.
//

import UIKit

class SubmitViewController: UIViewController {

    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 25
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 110),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -110),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35)
        ])
    }


}
