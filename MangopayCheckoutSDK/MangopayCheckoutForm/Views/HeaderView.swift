//
//  File.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import Foundation
#if os(iOS)
import UIKit
#endif

class HeaderView: UIView {

    lazy var titleLabel = UILabel.create(
        text: LocalizableString.CARD_INFO_TITLE,
        color: .black,
        font: UIFont.boldSystemFont(ofSize: 18),
        numberOfLines: 1
    )

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = -4
        flowLayout.minimumLineSpacing = -2

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.isPagingEnabled = false
        cv.register(CardCell.self, forCellWithReuseIdentifier: CardCell.id)
        cv.dataSource = self
        cv.delegate = self
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        return cv
    }()

    private lazy var vStack = UIStackView.create(
        spacing: 10,
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        views: [
            titleLabel,
            collectionView
        ]
    )

    var viewModel = CardListViewModel()
    
    init(cardConfig: CardConfig? = nil) {
        super.init(frame: .zero)
        viewModel.setCards(with: cardConfig)
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(vStack)

        vStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        vStack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        vStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true

        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    func set(_ cards: CardConfig?) {
        viewModel.setCards(with: cards)
        collectionView.reloadData()
    }
    
}

extension HeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CardCell.id,
            for: indexPath
        ) as? CardCell else {
            fatalError("CardCell not found ")
        }

        cell.configure(with: viewModel.card(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let card = viewModel.card(at: indexPath.row)
        return CGSize(width: 40, height: 20)
    }


}
