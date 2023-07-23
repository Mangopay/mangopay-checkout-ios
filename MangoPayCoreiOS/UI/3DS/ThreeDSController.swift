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
    let successUrl: URL?
    let failUrl: URL?
    public var authUrl: URL?
    var authUrlNavigation: WKNavigation?
    private let urlHelper: URLHelping

//    public weak var delegate: ThreeDSControllerDelegate?
    var onSuccess: ((String) -> ())?
    var onFailure: (() -> ())?

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

    convenience init(successUrl: URL?, failUrl: URL?) {
        self.init(successUrl: successUrl, failUrl: failUrl, urlHelper: URLHelper())
    }

    init(successUrl: URL?, failUrl: URL?, urlHelper: URLHelping) {
        self.successUrl = successUrl
        self.failUrl = failUrl
        self.urlHelper = urlHelper
        super.init(nibName: nil, bundle: nil)
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
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
//        let status = urlHelper.extractToken(from: webView.url!)
//        guard let paymentId = status.0, let paymentStatus = status.1 else { return }
        let status = urlHelper.extractPreAuth(from: webView.url!)
//        handleDismiss(status: paymentStatus, paymentId: paymentId)
//        handleDismiss(preAuthID: status)
        print("✅ didReceiveServerRedirectForProvisionalNavigation Logs", webView.url!)

    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        guard navigation == authUrlNavigation else {
//            return
//        }

//        logger?.log(.threeDSChallengeLoaded(success: true))
        print("✅ navigation Logs", webView.url!)
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        guard navigation == authUrlNavigation else {
//            return
//        }
//
//        logger?.log(.threeDSChallengeLoaded(success: false))
        print("✅ didFail", error, webView.url!)
    }

    private func handleDismiss(status: String, paymentId: String, preAuthID: String) {
        switch status {
        case "COMPLETED":
//            self.dismiss(animated: true) { [delegate] in
//                delegate?.onSuccess3D(paymentId: paymentId)
//            }
            self.navigationController?.popViewController(animated: true)
//            delegate?.onSuccess3D(paymentId: paymentId)
            self.onSuccess?(paymentId)

        case "FAILED":
            self.dismiss(animated: true) {
//                delegate?.onFailure3D()
                self.onFailure?()
            }
        default: return
        }
    }

    private func handleDismiss(preAuthID: String?) {
        guard let _preauth = preAuthID else {
//            delegate?.onFailure3D()
            self.onFailure?()
            return
        }
        self.navigationController?.popViewController(animated: true)
//        delegate?.onSuccess3D(paymentId: _preauth)
        self.onSuccess?(_preauth)
    }

}
