//
//  CampusMapWebView.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/20/23.
//
// Article: https://sarunw.com/posts/swiftui-webview/

import SwiftUI
import WebKit

struct CampusMapWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {

        return WKWebView()
    }

    // This method is called any time there is a state change
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
