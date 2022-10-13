//
//  File.swift
//  
//
//  Created by Elikem Savie on 13/10/2022.
//

import Foundation
import UIKit

class HeaderView: UIView {
    
    lazy var titleLabel = UILabel.create(text: "Card Information", numberOfLines: 1)

    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.minimumLineSpacing = 8

        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = true
        cv.register(CardCell.self, forCellWithReuseIdentifier: CardCell.id)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    private lazy var vStack = UIStackView.create(
        spacing: 8,
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        views: [
            titleLabel,
            collectionView
        ]
    )

    let viewModel = CardListViewModel()
    
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

}

extension HeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.count
        return 6
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CardCell.id,
            for: indexPath
        ) as? CardCell else {
            fatalError("CardCell not found ")
        }

//        cell.configure(with: viewModel.card(at: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 48, height: 20)
    }


}
