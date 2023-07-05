//
//  NewsFeedArticleViewRepresentable.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/28/23.
//

import SwiftUI
import WebKit

struct NewsFeedArticleWebViewRepresentable: UIViewRepresentable {
    let url: URL
    let delegeate: WebViewDelegate

    init(url: URL) {
        self.url = url
        self.delegeate = WebViewDelegate()
    }

    func makeUIView(context: Context) -> WKWebView {
        let deleteHeaderAndFooterScript = """
                        // Header
                        var element = document.getElementById("site-top-nav-container");
                        element.parentNode.removeChild(element);
                        element = document.getElementById("site-header-container");
                        element.parentNode.removeChild(element);
                        element = document.getElementById("site-navbar-container");
                        element.parentNode.removeChild(element);
                        element = document.getElementById("tncms-block-731531");
                        element.parentNode.removeChild(element);

                        // Share options
                        var elements = document.getElementsByClassName("share-container content-below");
                        while(elements.length > 0){
                            elements[0].parentNode.removeChild(elements[0]);
                        }
                        elements = document.getElementsByClassName("share-container content-above");
                        while(elements.length > 0){
                            elements[0].parentNode.removeChild(elements[0]);
                        }

                        // Footer
                        element = document.getElementById("tncms-region-article_bottom_content");
                        element.parentNode.removeChild(element);
                        element = document.getElementById("asset-below");
                        element.parentNode.removeChild(element);
                        element = document.getElementById("site-footer");
                        element.parentNode.removeChild(element);
                        element = document.getElementById("site-copyright-container");
                        element.parentNode.removeChild(element);

                        // Comment button
                        var svgElements = document.querySelectorAll('.tnt-comments');
                        for (var i = svgElements.length - 1; i >= 0; i--) {
                            svgElements[i].remove();
                        }
                        """
        var turnOffZoomScript: String {
            "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"
        }
        let userScript = WKUserScript(source: deleteHeaderAndFooterScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userScript2 = WKUserScript(source: turnOffZoomScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        let contentController = WKUserContentController()
        contentController.addUserScript(userScript)
        contentController.addUserScript(userScript2)

        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.userContentController = contentController

        let webView = WKWebView(frame: CGRect.zero, configuration: webViewConfiguration)
        webView.navigationDelegate = delegeate
        webView.uiDelegate = delegeate
        return webView
    }

    // This method is called any time there is a state change
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

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
