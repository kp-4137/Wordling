//
//  SubmitViewController.swift
//  Wordling
//
//  Created by Kishan Patel on 5/3/23.
//

import UIKit

protocol SubmitViewControllerDelegate: AnyObject {
    func submitBtnTapped(_ vc: SubmitViewController)
}

class SubmitViewController: UIViewController {
    
    weak var delegate: SubmitViewControllerDelegate?
    
    var observer: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        let submitBtn = createButton()
        view.addSubview(submitBtn)
        NSLayoutConstraint.activate([
                    submitBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 110),
                    submitBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -110),
                    submitBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
                    submitBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35)
                ])
        observer = NotificationCenter.default.addObserver(forName: Notification.Name("toggleSubmitBtn"),
                                                          object: nil,
                                                          queue: .main,
                                                          using: { notification in
            guard let object = notification.object as? Bool else { return }
            
            submitBtn.isEnabled = object
        })
    }
    
    func createButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = createConfig()
        button.addTarget(self, action: #selector(submitBtnTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }
    
    func createConfig() -> UIButton.Configuration {
        var config: UIButton.Configuration = .filled()
        config.baseBackgroundColor = .systemGreen
        config.title = "Submit"
        config.cornerStyle = .capsule
        return config
    }
    
    @objc func submitBtnTapped() {
        delegate?.submitBtnTapped(self)
    }

}
