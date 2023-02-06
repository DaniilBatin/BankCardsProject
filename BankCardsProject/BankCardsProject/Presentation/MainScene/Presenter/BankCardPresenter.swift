//
//  BankCardPresenter.swift
//  BankCardsProject
//
//  Created by Daniil Batin on 20.12.2022.
//

import UIKit

protocol BankCardPresenterProtocol: AnyObject {
    func onLoad()
    var sections: [ListSection] { get }
}

class BankCardPresenter {
    // MARK: - Properties
    let model: BankCardModelProtocol
    weak var view: BankCardViewControllerProtocol?
    var colorsForBackground: [UIColor]
    
    // MARK: - Init
    init(model: BankCardModelProtocol) {
        self.model = model
        colorsForBackground = ColorGenerator.generateColors(numberOfColors: model.cards.count)
    }
}

// MARK: - PresenterProtocol
extension BankCardPresenter: BankCardPresenterProtocol {
    var sections: [ListSection] {
        [
            BankCardSection(items: model.cards, sectionDelegate: self)
        ]
    }
    
    func onLoad() {
        view?.addSections(sections)
    }
}

// MARK: - BankCardSectionDelegate
extension BankCardPresenter: BankCardSectionDelegate {
    func bankCardSection(_ section: BankCardSection, itemIndexChanged index: Int) {        
        view?.setCardInfo(userInfo: model.cards[index])
        view?.setColorForBackgroundAndCollection(colorsForBackground[index], colorsForBackground[index+1])

    }
}
