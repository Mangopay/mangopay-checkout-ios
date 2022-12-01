//
//  CustomerCardListControllerViewController.swift
//  
//
//  Created by Elikem Savie on 30/10/2022.
//

import UIKit
import Foundation

class CustomerCardListController: UIViewController {

    lazy var closeButton = IconButton.create(
        title: "",
        iconSystemName: "xmark",
        iconSystemColor: .black
    ) { button in
        button.addTarget(self, action: #selector(self.closeParent), for: .touchUpInside)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.create(text: "Cards", font: .systemFont(ofSize: 24, weight: .bold))
        label.minimumScaleFactor = 0.7
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        return label
    }()

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.register(CardListCell.self, forCellReuseIdentifier: CardListCell.id)
        view.estimatedRowHeight = 200
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var containerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 20)
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        return view
    }()
    
    var implicitHeight: CGFloat {
        return UIScreen.main.bounds.height * 0.6
    }

    var cardLists = [ListCustomerCard]()
    var selectedAction: ((ListCustomerCard) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        layoutViews()
    }
    

    func initialize() {
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        view.addSubview(containerView)
    }

    func layoutViews() {
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: implicitHeight).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true

        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24).isActive = true
    
        closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24).isActive = true
        closeButton.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
    
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        tableView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24).isActive = true
        tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24).isActive = true

    }

    @objc func closeParent() {
        self.dismiss(animated: true)
    }

}

extension CustomerCardListController {

    static func showDatePicker(
        with controller: UIViewController?,
        title: String = "Set Date",
        buttonTitle: String = "Save Date",
        cardLists: [ListCustomerCard],
        handler: ((ListCustomerCard) -> ())?
    ) {
        let pickerVC = CustomerCardListController()
        pickerVC.cardLists = cardLists
        pickerVC.selectedAction = handler
        let nav = UINavigationController(rootViewController: pickerVC)
        nav.view.backgroundColor = .clear
        nav.modalPresentationStyle = .overCurrentContext
        controller?.present(nav, animated: true, completion: nil)
    }

}


extension CustomerCardListController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CardListCell.id,
            for: indexPath
        ) as? CardListCell else {
            fatalError("CardPickerView not found")
        }

        cell.render(card: cardLists[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = cardLists[indexPath.row]
        selectedAction?(selected)
        self.dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
