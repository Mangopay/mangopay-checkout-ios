//
//  WebViewController.swift
//  
//
//  Created by Elikem Savie on 11/12/2023.
//

import WebKit
#if os(iOS)
import UIKit
#endif

public class MGPWebViewController: UIViewController {

//    var webView: WKWebView!
    private var url: URL?
    private let urlHelper: URLHelping = URLHelper()
    
    private var onComplete: ((_3DSResult) -> ())?
    private var onError: ((Error?) -> ())?

    var authUrlNavigation: WKNavigation?

//    lazy var activityIndiicatorView: UIActivityIndicatorView = {
//       let view = UIActivityIndicatorView()
//        view.style = .large
//        view.translatesAutoresizingMaskIntoConstraints = false
//       return view
//    }()

    lazy var mgpWebView = MGPWebView()

    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let authUrl = url else {
            return
        }

        let authRequest = URLRequest(url: authUrl)
        mgpWebView.webView.navigationDelegate = self
        authUrlNavigation = mgpWebView.webView.load(authRequest)
        title = "Pay with Paypal"
        addBackButton()
    }
    
    public init(
        url: URL,
        onComplete: ((_3DSResult) -> ())?,
        onError: ((Error?) -> ())?
    ) {
        self.url = url
        self.onComplete = onComplete
        self.onError = onError
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        url = nil
        super.init(coder: aDecoder)
    }

    public override func loadView() {
        view = mgpWebView
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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

extension MGPWebViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("🤣 url: redirect", webView.url!)

        guard var _3dsResult = urlHelper.extract3DSResult(from: webView.url!, type: .cardDirect) else {
//            self.onError?(MGPError._3dsIdExtractionError)
            return
        }
        
        Task {
            
            do {
                let regResponse = try await PaymentCoreClient(
                    env: .t3
                ).getPayIn(clientId: "pablo123", apiKey: "B8hGcedwVBXpHnVJc6pu96gpBuLKuc3ohx3JSoT6NUec5MrmPu", payInId: _3dsResult.id)
  
                print("🤣 Get pay IN", regResponse)
                _3dsResult = _3DSResult(
                    type: .cardDirect,
                    status: .SUCCEEDED,
                    id: _3dsResult.id
                )
                self.handleDismiss(_3dsResult: _3dsResult)

            } catch {
                print("❌ getPayIn Error ")
                _3dsResult = _3DSResult(
                    type: .cardDirect,
                    status: .FAILED,
                    id: _3dsResult.id
                )
                self.handleDismiss(_3dsResult: _3dsResult)
            }
            
        }
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.onError?(MGPError._3dsError(additionalInfo: error.localizedDescription))
        mgpWebView.activityIndiicatorView.stopAnimating()
        print("🤣 url: navigation", webView.url!)
    }

    private func handleDismiss(_3dsResult: _3DSResult) {
        self.dismiss(animated: true) {
            self.onComplete?(_3dsResult)
        }
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mgpWebView.activityIndiicatorView.stopAnimating()
    }

}

extension MGPWebViewController {
//    static func openUrl(url: URL, in controller: UIViewController) {
//        let urlController = MGPWebViewController(url: url, onError: nil)
//        controller.present(urlController, animated: true)
//    }
}

