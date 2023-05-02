//
//  KeyCell.swift
//  Wordling
//
//  Created by Kishan Patel on 5/2/23.
//

import UIKit

class KeyCell: UICollectionViewCell {
    static let identifier = "KeyCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
