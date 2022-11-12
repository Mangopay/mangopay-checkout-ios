//
//  ThreeDSController.swift
//  
//
//  Created by Elikem Savie on 12/11/2022.
//

import UIKit
import WebKit

public protocol ThreeDSControllerDelegate: AnyObject {

    func onSuccess3D()

    func onFailure3D()

    func threeDSWebViewControllerAuthenticationDidSucceed(
        _ threeDSWebViewController: ThreeDSController,
        token: String?
    )

    func threeDSWebViewControllerAuthenticationDidFail(
        _ threeDSWebViewController:
        ThreeDSController
    )

}

public class ThreeDSController: UIViewController {

    var webView: WKWebView!
    let successUrl: URL?
    let failUrl: URL?
    public var authUrl: URL?
    var authUrlNavigation: WKNavigation?
    private let urlHelper: URLHelping

    public weak var delegate: ThreeDSControllerDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let authUrl = authUrl else {
            return
        }


        let authRequest = URLRequest(url: authUrl)
        webView.navigationDelegate = self
        authUrlNavigation = webView.load(authRequest)
    }
    
    public convenience init(successUrl successUrlString: String, failUrl failUrlString: String) {
        let successUrl = URL(string: successUrlString)
        let failUrl = URL(string: failUrlString)

        self.init(successUrl: successUrl, failUrl: failUrl)
    }

    public convenience init (successUrl: URL, failUrl: URL) {
        self.init(successUrl: .some(successUrl), failUrl: .some(failUrl))
    }

    /// Initializes a web view controller adapted to handle 3dsecure.
    convenience init(successUrl: URL?, failUrl: URL?) {
        // in 4.0.0 release we should ask for the environment
        self.init(successUrl: successUrl, failUrl: failUrl, urlHelper: URLHelper())
    }

    init(successUrl: URL?, failUrl: URL?, urlHelper: URLHelping) {
        self.successUrl = successUrl
        self.failUrl = failUrl
        self.urlHelper = urlHelper
        super.init(nibName: nil, bundle: nil)
    }

    /// Returns a newly initialized view controller with the nib file in the specified bundle.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Foundation.Bundle?) {
        successUrl = nil
        failUrl = nil
        urlHelper = URLHelper()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        successUrl = nil
        failUrl = nil
        urlHelper = URLHelper()
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle

    /// Creates the view that the controller manages.
    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }


}

extension ThreeDSController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let dismissed = navigationAction.request.url.map { handleDismiss(redirectUrl: $0) } ?? false

        decisionHandler(dismissed ? .cancel : .allow)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        guard navigation == authUrlNavigation else {
//            return
//        }

//        logger?.log(.threeDSChallengeLoaded(success: true))
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        guard navigation == authUrlNavigation else {
//            return
//        }
//
//        logger?.log(.threeDSChallengeLoaded(success: false))
    }

    private func handleDismiss(redirectUrl: URL) -> Bool {

        if let successUrl = successUrl,
           urlHelper.urlsMatch(redirectUrl: redirectUrl, matchingUrl: successUrl) {
            // success url, dismissing the page with the payment token

            self.dismiss(animated: true) { [urlHelper, delegate] in
                let token = urlHelper.extractToken(from: redirectUrl)
                delegate?.threeDSWebViewControllerAuthenticationDidSucceed(self, token: token)
                delegate?.onSuccess3D()
            }

            return true
        } else if let failUrl = failUrl,
                  urlHelper.urlsMatch(redirectUrl: redirectUrl, matchingUrl: failUrl) {
            // fail url, dismissing the page
            self.dismiss(animated: true) { [delegate] in
                delegate?.threeDSWebViewControllerAuthenticationDidFail(self)
                delegate?.onFailure3D()
            }

            return true
        }

        return false
    }
}
