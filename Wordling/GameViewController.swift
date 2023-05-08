//
//  GameViewController.swift
//  Wordling
//
//  Created by Kishan Patel on 5/8/23.
//

import UIKit

class GameViewController: UIViewController {
    
    let answer = "tiger"
    var guesses: [[Character?]] = Array(repeating: Array(repeating: nil, count: 5), count: 6)
    var submittedGuesses: [[Int?]] = Array(repeating: Array(repeating: nil, count: 5), count: 6)
    var guessNumber: Int = 0
    var keyColorMap: [Character: Int] = ["q": -1, "w": -1, "e": -1, "r": -1, "t": -1, "y": -1, "u": -1, "i": -1, "o": -1, "p": -1, "a": -1, "s": -1, "d": -1, "f": -1, "g": -1, "h": -1, "j": -1, "k": -1, "l": -1, "z": -1, "x": -1, "c": -1, "v": -1, "b": -1, "n": -1, "m": -1]
    
    let keyboardVC = KeyboardViewController()
    let gridVC = GridViewController()
    let submitVC = SubmitViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "WORDLE"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(dismissSelf))
        addChildren()
    }
    
    private func addChildren() {
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.delegate = self
        keyboardVC.datasource = self
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
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}

extension GameViewController: KeyboardViewControllerDelegate {
    
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

extension GameViewController: KeyboardViewControllerDataSource {
    var keyColorMapping: [Character : Int] {
        return keyColorMap
    }
}

extension GameViewController: GridViewControllerDataSource {
    var currentGuesses: [[Character?]] {
        return guesses
    }
    
    var currentGuessNumber: Int {
        return guessNumber
    }
    
    var currentSubmittedGuesses: [[Int?]] {
        return submittedGuesses
    }
}

extension GameViewController: SubmitViewControllerDelegate {
    func submitBtnTapped(_ vc: SubmitViewController) {
        let currentRow = guesses[guessNumber]
        for i in 0..<submittedGuesses[guessNumber].count {
            if answer.contains(currentRow[i] ?? "/") {
                if answer[answer.index(answer.startIndex, offsetBy: i)] == currentRow[i] {
                    submittedGuesses[guessNumber][i] = 2
                    keyColorMap[currentRow[i] ?? "/"] = 2
                } else {
                    submittedGuesses[guessNumber][i] = 1
                    if keyColorMap[currentRow[i] ?? "/"] != 2 {
                        keyColorMap[currentRow[i] ?? "/"] = 1
                    }
                }
            } else {
                submittedGuesses[guessNumber][i] = 0
                if keyColorMap[currentRow[i] ?? "/"] != 2 {
                    keyColorMap[currentRow[i] ?? "/"] = 0
                }
            }
        }
        guessNumber += 1
        NotificationCenter.default.post(name: NSNotification.Name("toggleSubmitBtn"), object: false)
        gridVC.reloadData()
        keyboardVC.reloadData()
        
        for i in 0..<submittedGuesses[guessNumber-1].count {
            if submittedGuesses[guessNumber-1][i] != 2 {
                if guessNumber == 6 {
                    let failureAlert = UIAlertController(title: "Failure", message: "Oops! You used all your guesses!", preferredStyle: .alert)
                    failureAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .systemRed.withAlphaComponent(0.5)
                    present(failureAlert, animated: true)
                }
                return
            }
        }
        let successAlert = UIAlertController(title: "Success", message: "You took \(guessNumber) guesses!", preferredStyle: .alert)
        successAlert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .systemGreen.withAlphaComponent(0.5)
        present(successAlert, animated: true)
    }
}
