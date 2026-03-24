//
//  LoginPage.swift
//  Ksync
//
//  Created by vishek on 24/03/26.
//
import SwiftUI
import WebKit

struct LoginPage: View {
    @AppStorage("authToken") var authToken: String? // 💾 Stores Raw Token
    @State private var isLoading: Double = 1.0
    @State private var injectScript: String? = nil
    
    // 📝 Native Form State
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var loginAttempted = false
    @State private var isSuccess = false // 🙈 Hide WebView immediately on success
    
    let loginURL = URL(string: "https://kiet.cybervidya.net/")!
    
    // 🛡️ ANTI-BOT USER AGENT
    // ❌ Disabled Custom UA to fix "Low Captcha Score"
    let userAgent = ""
    
    // ⚡️ Fast Login Script (Token Capture - Runs Continuously)
    let fastLoginScript = """
      (function() {
        var check = setInterval(function() {
            var token = localStorage.getItem('authenticationtoken');
            if (!token) {
                 token = sessionStorage.getItem('authenticationtoken');
            }
            if (!token) {
                 // Try to find in cookie
                 var match = document.cookie.match(new RegExp('(^| )authenticationtoken=([^;]+)'));
                 if (match) token = match[2];
            }

            if (token && token.length > 10) { 
                clearInterval(check);
                window.webkit.messageHandlers.ReactNativeWebView.postMessage(JSON.stringify({ token: token }));
            }
        }, 2000); // 🐢 Changed to 2s to avoid "Low Captcha Score"
      })();
    """

    var body: some View {
        ZStack {
            // 🕸️ WebView (Visible & Interactive)
            BunkWebView(
                url: loginURL,
                script: fastLoginScript,
                userAgent: userAgent,
                isLoading: $isLoading,
                onMessage: handleMessage,
                injectScript: $injectScript
            )
            .edgesIgnoringSafeArea(.all)
            .opacity(isSuccess ? 0 : 1) // 🙈 Instant Hide
            
            // 🌀 Loading Overlay
            if isLoading > 0.1 || isSuccess {
                ZStack {
                    Color.white.ignoresSafeArea() // Mask everything
                    if !isSuccess {
                        ProgressView("Loading...")
                    } else {
                        // Optional: Show "Success" or Logo while switching
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .onAppear {
            BunkWebView.clearWebViewData()
        }
    }

    // ... (rest of the file) ...

    func handleMessage(_ message: String) {
        guard let data = message.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              var token = json["token"] as? String else { return }
            
        // 🧹 Clean Quote from JSON string
        if token.hasPrefix("\"") && token.hasSuffix("\"") {
            token = String(token.dropFirst().dropLast())
        }
        if !token.contains("GlobalEducation") {
            token = "GlobalEducation \(token)"
        }
        
        print("\n🔑 TOKEN CAPTURED SUCCESS!")
        
        DispatchQueue.main.async {
            self.isSuccess = true // 🙈 Trigger Mask
            
            // Small delay to let mask appear before state change
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.authToken = token
                UserDefaults.standard.set(token, forKey: "authToken")
                self.loginAttempted = false
            }
        }
    }
}

// Helper for Placeholder Color
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

