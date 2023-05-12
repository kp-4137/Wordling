//
//  GridViewController.swift
//  Wordle
//
//  Created by Kishan Patel on 4/27/23.
//

import UIKit

protocol GridViewControllerDataSource: AnyObject {
    var currentGuesses: [[Character?]] {get}
    var currentSubmittedGuesses: [[Int?]] {get}
    var currentGuessNumber: Int {get}
    var currentNumOfLetters: Int? {get}
}

class GridViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var datasource: GridViewControllerDataSource?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }

}

extension GridViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource?.currentGuesses.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.currentNumOfLetters ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                    .dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell
                    else{
                        fatalError()
                    }
        cell.backgroundColor = nil
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        cell.layer.cornerRadius = 5
        cell.label.textColor = .systemGray
        cell.label.font = UIFont.boldSystemFont(ofSize: 20)
        
        let guesses = datasource?.currentGuesses ?? []
        if let letter = guesses[indexPath.section][indexPath.row] {
            cell.configure(with: letter)
        }
        
        let submittedGuesses = datasource?.currentSubmittedGuesses ?? []
        if let color = submittedGuesses[indexPath.section][indexPath.row] {
            cell.configure(with: color)
        }
        
        if indexPath.section == datasource?.currentGuessNumber {
            cell.layer.borderColor = UIColor.systemCyan.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numOfLetters: Int = datasource?.currentNumOfLetters ?? 0
        var spacing: Int = 4
        if numOfLetters == 4 {
            spacing = 20
        } else if numOfLetters == 6 {
            spacing = 2
        } else {
            spacing = 4
        }
        let margin: CGFloat = CGFloat(4 + (numOfLetters-1) * spacing)
        let size: CGFloat = (collectionView.frame.size.width - margin) / CGFloat(numOfLetters)
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }

}
