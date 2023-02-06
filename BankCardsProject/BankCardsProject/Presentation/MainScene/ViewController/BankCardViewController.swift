//
//  BankCardViewController.swift
//  BankCardsProject
//
//  Created by Daniil Batin on 20.12.2022.
//

import UIKit

protocol BankCardViewControllerProtocol: AnyObject {
    func addSections(_ sections: [ListSection])
    func setColorForBackgroundAndCollection(_ topColor: UIColor,_ bottomColor: UIColor)
    func setCardInfo(userInfo: UserCredentials)
}

class BankCardViewController: UIViewController {
    // MARK: - Properties
    let presenter: BankCardPresenterProtocol
    var gradientLayer: CAGradientLayer?
    private let screenRecordingProtectionService = ScreenRecordingProtectionService()
    
    // MARK: - Lazy properties
    private lazy var bankCardsCollectionView: ListCollectionView = {
       let collectionView = ListCollectionView()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.keyboardDismissMode = .onDrag
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var gradientView: UIView = {
        let view = UIView(frame: view.frame)
        return view
    }()
    
    private lazy var holderNameLabel: UILabel = {
       let label = UILabel()
        label.tintColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameOfBankLabel: UILabel = {
       let label = UILabel()
        label.tintColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var expireDateLabel: UILabel = {
       let label = UILabel()
        label.tintColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    init(presenter: BankCardPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpConstraints()
        setUpCollectionView()
        presenter.onLoad()
        screenRecordingProtectionService.startPreventingRecording()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         gradientView.hideContentOnScreenCapture()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        gradientView.removeHideContentOnScreenCapture()
    }
}

// MARK: - Private methods
private extension BankCardViewController {
    func setUpUI() {
        view.addSubview(gradientView)
        gradientView.addSubview(holderNameLabel)
        gradientView.addSubview(nameOfBankLabel)
        gradientView.addSubview(expireDateLabel)
        addGradient(topColor: UIColor.white.cgColor, buttomColor: UIColor.white.cgColor, startPoint: Point.top.point, endPoint: Point.bottom.point)
    }
    
    func setUpCollectionView() {
        gradientView.addSubview(bankCardsCollectionView)
        NSLayoutConstraint.activate([
            bankCardsCollectionView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: Constants.Layout.bankCardsCollectionViewInssets.left),
            bankCardsCollectionView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -Constants.Layout.bankCardsCollectionViewInssets.right),
            bankCardsCollectionView.topAnchor.constraint(equalTo: gradientView.safeAreaLayoutGuide.topAnchor, constant: 30),
            bankCardsCollectionView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            holderNameLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant:  Constants.Layout.defaultDistance),
            holderNameLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant:  -Constants.Layout.defaultDistance),
            holderNameLabel.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor),
            nameOfBankLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant:  Constants.Layout.defaultDistance),
            nameOfBankLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant:  -Constants.Layout.defaultDistance),
            nameOfBankLabel.topAnchor.constraint(equalTo: holderNameLabel.bottomAnchor, constant: Constants.Layout.defaultDistance),
            expireDateLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant:  Constants.Layout.defaultDistance),
            expireDateLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant:  -Constants.Layout.defaultDistance),
            expireDateLabel.topAnchor.constraint(equalTo: nameOfBankLabel.bottomAnchor, constant: Constants.Layout.defaultDistance)
        ])
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    func applySnapshot(sections: [ListSection]) {
        var snapshot = bankCardsCollectionView.diffableDataSource.snapshot()
        snapshot.deleteAllItems()
        
        sections.forEach { section in
            section.setUp(for: bankCardsCollectionView)
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }
        
        bankCardsCollectionView.diffableDataSource.apply(snapshot)
    }
    
    func addGradient(topColor:CGColor, buttomColor: CGColor, startPoint: CGPoint, endPoint: CGPoint) {
        gradientLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.colors = [topColor, buttomColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        self.gradientLayer = gradient
        
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
}

// MARK: - ViewControllerProtocol
extension BankCardViewController: BankCardViewControllerProtocol {
    func setCardInfo(userInfo: UserCredentials) {
        holderNameLabel.attributedText = attributedText(withString: String(format: "Name of holder: % @", userInfo.owner), boldString: userInfo.owner, font: holderNameLabel.font)
        nameOfBankLabel.attributedText = attributedText(withString: String(format: "Bank name: % @", userInfo.bankOfCard.rawValue), boldString: userInfo.bankOfCard.rawValue, font: nameOfBankLabel.font)
        expireDateLabel.attributedText = attributedText(withString: String(format: "Bank name: % @", userInfo.expireDate), boldString: userInfo.expireDate, font: expireDateLabel.font)
    }
    
    func setColorForBackgroundAndCollection(_ topColor: UIColor,_ bottomColor: UIColor) {
        gradientLayer?.colors = [topColor.cgColor, bottomColor.cgColor]
    }
    
    func addSections(_ sections: [ListSection]) {
        applySnapshot(sections: sections)
    }
}
