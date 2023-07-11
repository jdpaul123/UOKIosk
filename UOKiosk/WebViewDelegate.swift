//
//  WebViewDelegate.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 7/11/23.
//

import Foundation
import WebKit

class WebViewDelegate: NSObject, WKUIDelegate, WKNavigationDelegate {
    // MARK: - WKNavigationDelegate
    // Adapted from source: https://stackoverflow.com/questions/36231061/wkwebview-open-links-from-certain-domain-in-safari
    @MainActor
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url, let host = url.host, !host.hasPrefix("www.google.com"), UIApplication.shared.canOpenURL(url) {
                await UIApplication.shared.open(url)
//                print("Redirected to browser. No need to open it locally. With url: \(url)")
                return .cancel
            } else {
//                print("Open it locally")
                return .allow
            }
        } else {
//            print("not a user click")
            return .allow
        }
    }
}
