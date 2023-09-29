//
//  File.swift
//  
//
//  Created by Elikem Savie on 27/09/2023.
//

import Foundation
import UIKit

class NavView: UIView {
    
    lazy var titleLabel: UILabel = UILabel.create(text: "Checkout", color: .black, font: .boldSystemFont(ofSize: 18))

    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
        addSubview(closeButton)

        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        closeButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        closeButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
