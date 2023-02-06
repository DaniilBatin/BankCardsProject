//
//  CollectionView+DequeueReusableCell.swift
//  BankCardsProject
//
//  Created by Daniil Batin on 02.02.2023.
//

import UIKit

extension UICollectionView {
    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else { return nil }
        return cell
    }
}
