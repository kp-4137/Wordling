//
//  ViewController.swift
//  Wordle
//
//  Created by Kishan Patel on 4/27/23.
//

import UIKit

class ViewController: UIViewController {
    
    var guesses: [[Character?]] = Array(repeating: Array(repeating: nil, count: 5), count: 6)
    
    let keyboardVC = KeyboardViewController()
    let gridVC = GridViewController()
    let submitVC = SubmitViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addChildren()
    }
    
    private func addChildren() {
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
        
        addChild(gridVC)
        gridVC.didMove(toParent: self)
        gridVC.datasource = self
        gridVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridVC.view)
        
        addChild(submitVC)
        submitVC.didMove(toParent: self)
        submitVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitVC.view)
        
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            gridVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gridVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gridVC.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            gridVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.50),
            
            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: submitVC.view.topAnchor),
            keyboardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            submitVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            submitVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            submitVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }


}

extension ViewController: KeyboardViewControllerDelegate {
    
    func keyboardViewController(_ vc: KeyboardViewController, didTapKey letter: Character) {
        if letter == "." {
            deleteLetter()
        } else {
            insertLetter(letter)
        }
        gridVC.reloadData()
    }
    
    func insertLetter(_ letter: Character) {
        var stop = false
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                    guesses[i][j] = letter
                    stop = true
                    break
                }
            }
            if stop {
                break
            }
        }
    }
    
    func deleteLetter() {
        if guesses[0][0] == nil {
            return
        }
        if guesses[guesses.count - 1][guesses[guesses.count - 1].count - 1] != nil {
            guesses[guesses.count - 1][guesses[guesses.count - 1].count - 1] = nil
            return
        }
        var stop = false
        for i in 0..<guesses.count {
            for j in 0..<guesses[i].count {
                if guesses[i][j] == nil {
                    if j > 0 {
                        guesses[i][j-1] = nil
                    } else {
                        guesses[i-1][guesses[i-1].count - 1] = nil
                    }
                    stop = true
                    break
                }
            }
            if stop {
                break
            }
        }
    }
    
}

extension ViewController: GridViewControllerDataSource {
    var currentGuesses: [[Character?]] {
        return guesses
    }
}
