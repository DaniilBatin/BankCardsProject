//
//  SceneDelegate.swift
//  BankCardsProject
//
//  Created by Daniil Batin on 20.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainFlowFactory.instantiateBankCardPage()
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window?.frame ?? .zero
           blurEffectView.tag = Constants.Tag.blurEffectView

        window?.addSubview(blurEffectView)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        window?.viewWithTag(Constants.Tag.blurEffectView)?.removeFromSuperview()
    }
}
