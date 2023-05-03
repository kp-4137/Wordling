//
//  SubmitViewController.swift
//  Wordling
//
//  Created by Kishan Patel on 5/3/23.
//

import UIKit

class SubmitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createButton()
    }
    
    func createButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = createConfig()
        view.addSubview(button)
        NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 110),
                    button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -110),
                    button.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
                    button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35)
                ])
    }
    
    func createConfig() -> UIButton.Configuration {
        var config: UIButton.Configuration = .filled()
        config.baseBackgroundColor = .systemGreen
        config.title = "Submit"
        config.cornerStyle = .capsule
        return config
    }
    

}
