//
//  CellsReusingUtils.swift
//  AvitoTech-TraineeAssignment
//
//  Created by Богдан Полыгалов on 29.08.2023.
//

import UIKit

protocol ReuseIdentifying {
    static var defaultReuseIdentifier: String { get }
}

extension ReuseIdentifying where Self: UICollectionViewCell {
    static var defaultReuseIdentifier: String {
        NSStringFromClass(self).components(separatedBy: ".").last ?? NSStringFromClass(self)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReuseIdentifying {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: ReuseIdentifying {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            assertionFailure("Нельзя взять ячейку: \(T.defaultReuseIdentifier) для: \(indexPath)")
            return T()
        }
        return cell
    }

    func cellForItem<T: UICollectionViewCell>(at indexPath: IndexPath) -> T where T: ReuseIdentifying {
        guard let cell = cellForItem(at: indexPath) as? T else {
            assertionFailure("Не могу найти ячейку: \(T.defaultReuseIdentifier) для: \(indexPath)")
            return T()
        }
        return cell
    }
}
