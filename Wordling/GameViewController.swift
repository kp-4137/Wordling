//
//  GameViewController.swift
//  Wordling
//
//  Created by Kishan Patel on 5/8/23.
//

import UIKit

class GameViewController: UIViewController {
    
    var numOfLetters: Int? = nil
    var difficulty: Int? = nil
    var answer: String? = nil
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
        title = "WORDLING"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(dismissSelf))
        if let numOfLetters = numOfLetters, let difficulty = difficulty {
            guesses = Array(repeating: Array(repeating: nil, count: numOfLetters), count: difficulty)
            submittedGuesses = Array(repeating: Array(repeating: nil, count: numOfLetters), count: difficulty)
        }
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
    
    var currentNumOfLetters: Int? {
        return numOfLetters
    }
}

extension GameViewController: SubmitViewControllerDelegate {
    func submitBtnTapped(_ vc: SubmitViewController) {
        if answer == nil {
            struct Words: Decodable {
                let fourLetterWords: [String]
                let fiveLetterWords: [String]
                let sixLetterWords: [String]
            }
            guard let url = Bundle.main.url(forResource: "words", withExtension: "json"),
                  let data = try? Data(contentsOf: url),
                  let words = try? JSONDecoder().decode(Words.self, from: data) else {
                fatalError("Failed to load words.json")
            }
            var wordsArray: [String] = []
            if numOfLetters == 4 {
                wordsArray = words.fourLetterWords
            } else if numOfLetters == 5 {
                wordsArray = words.fiveLetterWords
            } else if numOfLetters == 6 {
                wordsArray = words.sixLetterWords
            }
            answer = wordsArray.randomElement()!
        }
        let currentRow = guesses[guessNumber]
        let currentGuessString = String(currentRow.compactMap { $0 })
        isValid(word: currentGuessString, apiKey: "7adf5b3a-3c5f-46db-9056-8d1ab69045d2") { (result) in
            DispatchQueue.main.async {
                if result == false && self.answer != currentGuessString {
                    self.showInvalidWordAlert(message: "Word not found in our dictionary", duration: 1.0)
                    return
                }
                for i in 0..<self.submittedGuesses[self.guessNumber].count {
                    if self.answer!.contains(currentRow[i] ?? "/") {
                        if self.answer![self.answer!.index(self.answer!.startIndex, offsetBy: i)] == currentRow[i] {
                            self.submittedGuesses[self.guessNumber][i] = 2
                            self.keyColorMap[currentRow[i] ?? "/"] = 2
                        } else {
                            self.submittedGuesses[self.guessNumber][i] = 1
                            if self.keyColorMap[currentRow[i] ?? "/"] != 2 {
                                self.keyColorMap[currentRow[i] ?? "/"] = 1
                            }
                        }
                    } else {
                        self.submittedGuesses[self.guessNumber][i] = 0
                        if self.keyColorMap[currentRow[i] ?? "/"] != 2 {
                            self.keyColorMap[currentRow[i] ?? "/"] = 0
                        }
                    }
                }
                self.guessNumber += 1
                NotificationCenter.default.post(name: NSNotification.Name("toggleSubmitBtn"), object: false)
                self.gridVC.reloadData()
                self.keyboardVC.reloadData()
                var alertTitle: String = ""
                var alertMessage: String = ""
                for i in 0..<self.submittedGuesses[self.guessNumber-1].count {
                    if self.submittedGuesses[self.guessNumber-1][i] != 2 {
                        if self.guessNumber == self.difficulty {
                            alertTitle = "Failure"
                            alertMessage = "Oops! You used all your guesses! The correct answer was \(self.answer!.uppercased())"
                            break
                        }
                        return
                    }
                }
                if alertTitle == "" {
                    alertTitle = "Success"
                    alertMessage = "You took \(self.guessNumber) guesses!"
                }
                let finishAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                let returnAction = UIAlertAction(title: "Back to Home", style: .destructive) { (action:UIAlertAction!) in
                    finishAlert.dismiss(animated: true)
                    let homeVC = ViewController()
                    let navVC = UINavigationController(rootViewController: homeVC)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                }
                let newGameAction = UIAlertAction(title: "New Game", style: .default) { (action:UIAlertAction!) in
                    finishAlert.dismiss(animated: true)
                    self.answer = nil
                    self.guesses = Array(repeating: Array(repeating: nil, count: self.numOfLetters!), count: self.difficulty!)
                    self.submittedGuesses = Array(repeating: Array(repeating: nil, count: self.numOfLetters!), count: self.difficulty!)
                    self.guessNumber = 0
                    self.keyColorMap = ["q": -1, "w": -1, "e": -1, "r": -1, "t": -1, "y": -1, "u": -1, "i": -1, "o": -1, "p": -1, "a": -1, "s": -1, "d": -1, "f": -1, "g": -1, "h": -1, "j": -1, "k": -1, "l": -1, "z": -1, "x": -1, "c": -1, "v": -1, "b": -1, "n": -1, "m": -1]
                    self.gridVC.reloadData()
                    self.keyboardVC.reloadData()
                }
                finishAlert.addAction(returnAction)
                finishAlert.addAction(newGameAction)
                self.present(finishAlert, animated: true)
            }
        }
    }

    func isValid(word: String, apiKey: String, completion: @escaping (Bool) -> Void) {
        let urlString = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/\(word)?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(false)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let data = data else {
                print("Invalid data")
                completion(false)
                return
            }
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                if let jsonArray = jsonArray, jsonArray.count > 0 {
                    // Word is valid
                    completion(true)
                } else {
                    // Word is invalid
                    completion(false)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                completion(false)
            }
        }
        task.resume()
    }
    
    func showInvalidWordAlert(message: String, duration: Double) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        // Dismiss the alert after a certain duration
        let timer = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: timer) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
}
