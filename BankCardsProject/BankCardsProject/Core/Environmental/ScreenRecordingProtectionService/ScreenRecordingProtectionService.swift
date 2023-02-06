//
//  ScreenProtector.swift
//  BankCardsProject
//
//  Created by Daniil Batin on 06.02.2023.
//

import UIKit

final class ScreenRecordingProtectionService {
    // MARK: - Enum(s)
    private enum Constants {
        enum Layout {
            static let infoLabelHorizontalIndent = 20.0
        }
    }
    
    // MARK: - Lazy properties
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Screen recording is not allowed at our app!"
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var warningWindow: UIWindow = {
        let window = UIWindow()
        window.backgroundColor = .black
        window.windowLevel = UIWindow.Level.statusBar + 1
        window.clipsToBounds = true
        
        return window
    }()
    
    private var appwindow: UIWindow? {
        return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
    }
    
    // MARK: - Init
    init() {
        setUpUI()
    }
    
    // MARK: - Methods
    func startPreventingRecording() {
        NotificationCenter.default.addObserver(self, selector: #selector(didDetectRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
    }
}

// MARK: - Private methods
private extension ScreenRecordingProtectionService {
    func setUpUI() {
        warningWindow.addSubview(infoLabel)

        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: warningWindow.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: warningWindow.centerYAnchor),
            infoLabel.leadingAnchor.constraint(greaterThanOrEqualTo: warningWindow.leadingAnchor, constant: Constants.Layout.infoLabelHorizontalIndent),
            infoLabel.trailingAnchor.constraint(lessThanOrEqualTo: warningWindow.trailingAnchor, constant: -Constants.Layout.infoLabelHorizontalIndent)
        ])
    }
    
    @objc func didDetectRecording() {
        DispatchQueue.main.async {
            self.appwindow?.isHidden = UIScreen.main.isCaptured
            
            if UIScreen.main.isCaptured {
                self.presentWarningWindow()
            } else {
                self.warningWindow.removeFromSuperview()
                self.warningWindow.windowScene = nil
            }
        }
    }
    
    func hideScreen() {
        appwindow?.isHidden = UIScreen.main.isCaptured
    }
    
    func presentWarningWindow() {
        warningWindow.removeFromSuperview()
        warningWindow.windowScene = nil

        guard let frame = appwindow?.bounds else { return }

        let windowScene = UIApplication.shared
            .connectedScenes
            .first {
                $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive
            }
        
        if let windowScene = windowScene as? UIWindowScene {
            warningWindow.windowScene = windowScene
        }

        warningWindow.frame = frame
        warningWindow.isHidden = false

        UIView.animate(withDuration: 0.15) {
            self.infoLabel.alpha = 1.0
            self.infoLabel.transform = .identity
        }
        
        warningWindow.makeKeyAndVisible()
    }
}
