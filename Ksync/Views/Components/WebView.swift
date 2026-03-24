//
//  WebView.swift
//  Ksync
//
//  Created by vishek on 24/03/26.
//
import SwiftUI
import WebKit

// 🌐 WEBVIEW COMPONENT (iOS Only)
// 🌐 WEBVIEW COMPONENT (iOS Only)
struct BunkWebView: UIViewRepresentable {
    let url: URL
    let script: String
    let userAgent: String
    @Binding var isLoading: Double
    var onMessage: (String) -> Void
    
    // ⚡️ New: Allow External Script Injection
    @Binding var injectScript: String?

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        
        // 🔥 CRITICAL FIX: Cookies/Cache enable
        config.websiteDataStore = WKWebsiteDataStore.default()
        
        // ⚡️ Faster Rendering
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        let controller = WKUserContentController()
        controller.add(context.coordinator, name: "ReactNativeWebView")
        config.userContentController = controller
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        
        // 🔥 Set User Agent (Only if provided)
        if !userAgent.isEmpty {
            webView.customUserAgent = userAgent
        }
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url == nil {
            var request = URLRequest(url: url)
            request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
            request.networkServiceType = .responsiveData // ⚡️ Prioritize
            request.cachePolicy = .useProtocolCachePolicy
            request.timeoutInterval = 15 // Fail fast if stuck
            uiView.load(request)
        }
        
        // 💉 Handle Script Injection
        if let script = injectScript {
            print("💉 Injecting Script...")
            uiView.evaluateJavaScript(script) { _, error in
                if let error = error { print("❌ Injection Error: \(error.localizedDescription)") }
            }
            // Reset after injection
            DispatchQueue.main.async {
                self.injectScript = nil // Reset to avoid loop
            }
        }
    }

    static func clearWebViewData() {
        print("🧹 Clearing WebView Data...")
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: BunkWebView
        init(_ parent: BunkWebView) { self.parent = parent }
        
        func userContentController(_ cc: WKUserContentController, didReceive msg: WKScriptMessage) {
            if let body = msg.body as? String { parent.onMessage(body) }
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async { self.parent.isLoading = 0.2 }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript(parent.script, completionHandler: nil)
            // ⚡️ Quicker Transition
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.parent.isLoading = 0.0
            }
        }
    }
}

