//
//  ThreeDSController.swift
//  
//
//  Created by Elikem Savie on 12/11/2022.
//

import WebKit
#if os(iOS)
import UIKit
#endif

public protocol ThreeDSControllerDelegate: AnyObject {
    func onSuccess3D(paymentId: String)
    func onFailure3D()
}

public class ThreeDSController: UIViewController {

    var webView: WKWebView!
    public var secureModeReturnURL: URL?
    var authUrlNavigation: WKNavigation?
    private let urlHelper: URLHelping = URLHelper()
    private var onComplete: ((_3DSResult) -> ())?
    private var onError: ((Error?) -> ())?
    private var transactionType: _3DSTransactionType!

    lazy var activityIndiicatorView: UIActivityIndicatorView = {
       let view = UIActivityIndicatorView()
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let authUrl = secureModeReturnURL else {
            return
        }

        let authRequest = URLRequest(url: authUrl)
        webView.navigationDelegate = self
        authUrlNavigation = webView.load(authRequest)
        title = "3DS authentication"
        addBackButton()
    }

    init(
        secureModeReturnURL: URL,
        secureModeRedirectURL: URL?,
        transactionType: _3DSTransactionType?,
        onComplete: ((_3DSResult) -> ())?,
        onError: ((Error?) -> ())?
    ) {
        self.transactionType = transactionType
        self.onError = onError
        self.secureModeReturnURL = secureModeReturnURL
        self.onComplete = onComplete
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        secureModeReturnURL = nil
        super.init(coder: aDecoder)
    }

    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.addSubview(activityIndiicatorView)
        activityIndiicatorView.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        activityIndiicatorView.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
        webView.bringSubviewToFront(activityIndiicatorView)
        activityIndiicatorView.startAnimating()
        activityIndiicatorView.hidesWhenStopped = true
        view = webView
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func dismiss3DS() {
        self.dismiss(animated: true)
    }

    func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.setTitle("", for: .normal)
        backButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc func closeTapped() {
        self.displayAlert(
            with: "Are you sure you want to leave",
            message: "",
            preferredStyle: .alert,
            actions: [
                UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }),
                UIAlertAction(title: "No", style: .default)
            ]
            
        )
    }

}

extension ThreeDSController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {

        guard let _3dsResult = urlHelper.extract3DSResult(from: webView.url!, type: transactionType) else {
            self.onError?(MGPError._3dsIdExtractionError)
            return
        }
        handleDismiss(_3dsResult: _3dsResult)
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.onError?(MGPError._3dsError(additionalInfo: error.localizedDescription))
        activityIndiicatorView.stopAnimating()
    }

    private func handleDismiss(_3dsResult: _3DSResult) {
        self.dismiss(animated: true) {
            self.onComplete?(_3dsResult)
        }
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndiicatorView.stopAnimating()
    }

}
