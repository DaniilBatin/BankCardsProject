//
//  MainFactory.swift
//  BankCardsProject
//
//  Created by Daniil Batin on 02.02.2023.
//

import Foundation

final class MainFlowFactory {
    // MARK: - Public methods
    static func instantiateBankCardPage() -> BankCardViewController {
        let model = BankCardModel()
        let presenter = BankCardPresenter(model: model)
        let viewController = BankCardViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
