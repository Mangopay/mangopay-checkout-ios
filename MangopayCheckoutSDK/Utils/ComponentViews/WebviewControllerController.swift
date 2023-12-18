//
//  WebviewControllerController.swift
//  
//
//  Created by Elikem Savie on 18/12/2023.
//

import UIKit
import SafariServices

public class WebViewController: UIViewController {

    public static func openWebView(with url: String) -> SFSafariViewController? {
        guard let url = URL(string: url) else { return nil }
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = true
        let vc = SFSafariViewController(url: url, configuration: config)
        vc.preferredBarTintColor = .black
        vc.preferredControlTintColor = .white
        vc.dismissButtonStyle = .done
        return vc
    }

}
