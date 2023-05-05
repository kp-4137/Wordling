//
//  ViewController.swift
//  Wordle
//
//  Created by Kishan Patel on 4/27/23.
//

import UIKit

class ViewController: UIViewController {
    
    var guesses: [[Character?]] = Array(repeating: Array(repeating: nil, count: 5), count: 6)
    var guessNumber: Int = 0
    
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
        submitVC.delegate = self
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
        for j in 0..<guesses[guessNumber].count {
            if guesses[guessNumber][j] == nil {
                guesses[guessNumber][j] = letter
                break
            }
        }
        if guesses[guessNumber][guesses[guessNumber].count - 1] != nil {
            NotificationCenter.default.post(name: NSNotification.Name("toggleSubmitBtn"), object: true)
        }
    }
    
    func deleteLetter() {
        var currentRow = guesses[guessNumber]
        if currentRow[0] == nil {
            return
        } else if currentRow[currentRow.count - 1] != nil {
            currentRow[currentRow.count - 1] = nil
            NotificationCenter.default.post(name: NSNotification.Name("toggleSubmitBtn"), object: false)
        } else {
            for j in 1..<currentRow.count {
                if currentRow[j] == nil {
                    currentRow[j-1] = nil
                    break
                }
            }
        }
        guesses[guessNumber] = currentRow
    }
    
}

extension ViewController: GridViewControllerDataSource {
    var currentGuesses: [[Character?]] {
        return guesses
    }
    
    var currentGuessNumber: Int {
        return guessNumber
    }
}

extension ViewController: SubmitViewControllerDelegate {
    func submitBtnTapped(_ vc: SubmitViewController) {
        let currentRow = guesses[guessNumber]
        if currentRow[currentRow.count - 1] != nil {
            guessNumber += 1
            NotificationCenter.default.post(name: NSNotification.Name("toggleSubmitBtn"), object: false)
            gridVC.reloadData()
        }
    }
}
