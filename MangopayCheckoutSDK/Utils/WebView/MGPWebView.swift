//
//  MGPWebView.swift
//  
//
//  Created by Elikem Savie on 13/12/2023.
//

import UIKit
import WebKit

class MGPWebView: UIView {

    var webView: WKWebView!

    lazy var activityIndiicatorView: UIActivityIndicatorView = {
       let view = UIActivityIndicatorView()
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    init() {
        super.init(frame: .zero)
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()
        webView = WKWebView(frame: .init(x: 0, y: 96, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), configuration: webConfiguration)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
//        webView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        webView.addSubview(activityIndiicatorView)
        activityIndiicatorView.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        activityIndiicatorView.centerYAnchor.constraint(equalTo: webView.centerYAnchor, constant: -50).isActive = true
        webView.bringSubviewToFront(activityIndiicatorView)
        activityIndiicatorView.startAnimating()
        activityIndiicatorView.hidesWhenStopped = true
    
        self.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }


}
