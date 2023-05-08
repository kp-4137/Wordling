//
//  KeyCell.swift
//  Wordling
//
//  Created by Kishan Patel on 5/2/23.
//

import UIKit

class KeyCell: UICollectionViewCell {
    static let identifier = "KeyCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func configure(with letter: Character) {
        if letter == "." {
            label.text = "DEL"
            return
        }
        label.text = String(letter).uppercased()
    }
    
    func configure(with color: Int) {
        if color == -1 {
            backgroundColor = .darkGray
        } else if color == 0 {
            backgroundColor = .systemGray
        } else if color == 1 {
            backgroundColor = .systemOrange
        } else {
            backgroundColor = .systemGreen
        }
        label.textColor = .white
        layer.borderWidth = 0
    }
    
}
