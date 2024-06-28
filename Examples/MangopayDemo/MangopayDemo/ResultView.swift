//
//  ResultView.swift
//  MangopayDemo
//
//  Created by Elikem Savie on 15/11/2023.
//

import Foundation
import UIKit

class ResultView: UIViewController {

    lazy var congratsView: CongratsView = {
        let view = CongratsView.fromNib() as CongratsView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        view.isOpaque = true
        view.backgroundColor = .white
        return view
    }()
    
    static var shared: ResultView {
        return generateNewLoaderInstance()
    }

    static func generateNewLoaderInstance() -> ResultView {
        return ResultView()
    }

    static func show(title: String = "Payment Succesful", result: String) {
          guard let view = UIApplication.shared.keyWindow else { return }
          let loader = ResultView.shared
          loader.setupView()
          loader.congratsView.renderLabel(title: title, result: result)
          loader.view.tag = 100
          view.addSubview(loader.view)
          loader.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
          loader.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
          loader.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
          loader.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
      }

    private func setupView() {
        view.backgroundColor = .lightGray.withAlphaComponent(0.6)
        view.addSubview(congratsView)
        congratsView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        congratsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        congratsView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 32).isActive = true
    }

    static func hide() {
        guard let view = UIApplication.shared.keyWindow else { return }
        view.subviews.first(where: {$0.tag == 100})?.removeFromSuperview()
      }

}
