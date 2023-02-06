//
//  UIView+ContentOnScreenCapture.swift
//  BankCardsProject
//
//  Created by Daniil Batin on 02.02.2023.
//

import UIKit

extension UIView {
    func hideContentOnScreenCapture() {
        DispatchQueue.main.async {
            let field = UITextField()
            field.isSecureTextEntry = true
            self.addSubview(field)
            field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.layer.superlayer?.addSublayer(field.layer)
            field.layer.sublayers?.first?.addSublayer(self.layer)
        }
    }
    
    func removeHideContentOnScreenCapture() {
        self.layer.sublayers?.removeFirst()
    }
}
