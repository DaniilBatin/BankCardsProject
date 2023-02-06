//
//  CollectionView+Register.swift
//  BankCardsProject
//
//  Created by Daniil Batin on 20.12.2022.
//

import UIKit

extension UICollectionView {
    final func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
}
