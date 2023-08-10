//
//  ThreeDSController.swift
//  
//
//  Created by Elikem Savie on 12/11/2022.
//

import WebKit
#if os(iOS)
import UIKit
import MangoPaySdkAPI
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

    var onSuccess: ((String) -> ())?
    var onFailure: ((Error?) -> ())?

    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let authUrl = secureModeReturnURL else {
            return
        }

        let authRequest = URLRequest(url: authUrl)
        webView.navigationDelegate = self
        authUrlNavigation = webView.load(authRequest)
    }

    init(
        secureModeReturnURL: URL,
        secureModeRedirectURL: URL?,
        onSuccess: ((String) -> ())?,
        onFailure: ((Error?) -> ())?
    ) {
        self.onSuccess = onSuccess
        self.onFailure = onFailure
        self.secureModeReturnURL = secureModeReturnURL
        super.init(nibName: nil, bundle: nil)
    }

    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        secureModeReturnURL = nil
        super.init(coder: aDecoder)
    }

    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }

    func dismiss3DS() {
        self.dismiss(animated: true)
    }

}

extension ThreeDSController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {

        guard let payinID = urlHelper.extractPreAuth(from: webView.url!) else { return }
        handleDismiss(paymentId: payinID)
//        handleDismiss(preAuthID: status)
        print("✅ didReceiveServerRedirectForProvisionalNavigation Logs", webView.url!)
        print("✅ status Logs", payinID)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("✅ navigation Logs", webView.url!)
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("✅ didFail", error, webView.url!)
        self.onFailure?(MGPError._3dsError(additionalInfo: error.localizedDescription))
    }

    private func handleDismiss(paymentId: String) {
        Task {
            guard let payIn = await check3DSStatus(paymentID: paymentId), let status = payIn.statusenum else { return }
    
            self.dismiss(animated: true) {
                switch status {
                case .success:
                    self.onSuccess?(paymentId)
                case .failed:
                    self.onFailure?(MGPError._3dsUserFailedChallenge(reaon: payIn.resultCode))
                }
            }
        }
    }

    private func check3DSStatus(paymentID: String) async -> PayIn? {
        do {
            let payIn = try await PaymentCoreClient(
                env: .sandbox
            ).getPayIn(
                clientId: MangoPayCoreiOS.clientId,
                apiKey: "7fOfvt3ozv6vkAp1Pahq56hRRXYqJqNXQ4D58v5QCwTocCVWWC",
                payInId: paymentID
            )
            return payIn
        } catch {
            print("❌ Error Getting PayIn", error.localizedDescription)
            self.onFailure?(MGPError._3dsError(additionalInfo: error.localizedDescription))
            return nil
        }
    }

}
