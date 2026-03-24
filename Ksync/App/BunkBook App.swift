//
//  BunkBook App.swift
//  Ksync
//
//  Created by vishek on 24/03/26.
//
import SwiftUI

@main
struct BunkBookApp: App {
    @AppStorage("authToken") var authToken: String?
    @State private var isSplashFinished = false
    
    
    @StateObject private var sharedViewModel = HomeViewModel()
    
    init() {
       
        NotificationManager.shared.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            if isSplashFinished {
                if authToken != nil && !authToken!.isEmpty {
                    
                    MainTabView(viewModel: sharedViewModel)
                } else {
                   
                    LoginPage()
                }
            } else {
                
                SplashScreenView(isFinished: $isSplashFinished, viewModel: sharedViewModel)
            }
        }
        .onChange(of: authToken) { oldToken, newToken in
            if let token = newToken, !token.isEmpty {
                print("🔄 Token detected! Refreshing ViewModel...")
                Task { await sharedViewModel.fetchData() }
            }
        }
    }
}

