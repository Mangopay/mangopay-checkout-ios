//
//  File.swift
//  
//
//  Created by Elikem Savie on 22/09/2023.
//

import Foundation
import UIKit

class Loader: UIViewController {

    lazy var activityIndicator: UIActivityIndicatorView = {
       let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.heightAnchor.constraint(equalToConstant: 60).isActive = true
        activity.widthAnchor.constraint(equalToConstant: 60).isActive = true
        activity.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activity.startAnimating()
        return activity
    }()

    static var shared: Loader {
        return generateNewLoaderInstance()
    }

    static func generateNewLoaderInstance() -> Loader {
        return Loader()
    }

    static func show() {
          guard let view = UIApplication.shared.keyWindow else { return }
          let loader = Loader.shared
          loader.setupView()
          loader.view.tag = 987
          view.addSubview(loader.view)
          loader.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
          loader.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
          loader.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
          loader.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
      }

    private func setupView() {
        view.backgroundColor = .lightGray.withAlphaComponent(0.6)
        view.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    static func hide() {
        guard let view = UIApplication.shared.keyWindow else { return }
        view.subviews.first(where: {$0.tag == 987})?.removeFromSuperview()
      }

}
