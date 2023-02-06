//
//  UserCredentials.swift
//  BankCardsProject
//
//  Created by Daniil Batin on 20.12.2022.
//

import Foundation

enum BankOfCard: String {
    case cosmos = "COSMOS"
    case easyBank = "EASY BANK"
    case newYorkBank = "NEW YORK BANK"
}

enum TypeOfCard {
    case visa
    case masterCard
}

struct UserCredentials: Hashable {
    // MARK: - Properties
    let cardNumber: String
    let expireDate: String
    let owner: String
    let bankOfCard: BankOfCard
    let typeOfCard: TypeOfCard
}

// MARK: - CellModelConformance
extension UserCredentials: BankCardCollectionViewCellProtocol {}
