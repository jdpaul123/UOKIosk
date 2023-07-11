//
//  CampusMapWebView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/20/23.
//
// Article: https://sarunw.com/posts/swiftui-webview/

import SwiftUI
import WebKit

struct CampusMapWebViewRepresentable: UIViewRepresentable {
    let url: URL
    let viewController: CampusMapViewController

    init(url: URL) {
        self.url = url
        viewController = CampusMapViewController(url: url)
    }

    func makeUIView(context: Context) -> WKWebView {
        return viewController.webView
    }

    // This method is called any time there is a state change
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func reloadHome() {
        let request = URLRequest(url: self.url)
        viewController.webView.load(request)
    }

    func reload() {
        viewController.webView.reload()
    }
}

class CampusMapViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    var webView: WKWebView
    var activityIndicator: UIActivityIndicatorView
    var url: URL

    init(url: URL) {
        self.url = url
        webView = WKWebView(frame: CGRect.zero)
        activityIndicator = UIActivityIndicatorView(style: .large)
        super.init(nibName: nil, bundle: nil)

        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = self
        webView.uiDelegate = self

        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()

        webView.addSubview(activityIndicator)
        webView.bringSubviewToFront(activityIndicator)
        view.addSubview(webView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
}
