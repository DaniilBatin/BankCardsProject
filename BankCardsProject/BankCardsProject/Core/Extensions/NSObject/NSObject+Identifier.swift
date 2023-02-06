//
//  NSObject+Identifier.swift
//  BankCardsProject
//
//  Created by Daniil Batin on 20.12.2022.
//

import Foundation

extension NSObject {
    static var identifier: String { "\(String(describing: Self.self))ID" }
}
