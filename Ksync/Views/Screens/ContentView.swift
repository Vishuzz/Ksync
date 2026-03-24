//
//  ContentView.swift
//  Ksync
//
//  Created by vishek on 24/03/26.
//
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct MainTabView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        TabView {
            // 🏠 Home Tab
            HomeScreen(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            // 📅 Schedule Tab
            ScheduleScreen()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Time Table")
                }
            
            // 📝 Exams Tab (UPDATED ✅)
            ExamMainView(viewModel: viewModel) // 🔥 Yahan change kiya hai
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Exams")
                }
            
            // ℹ️ About Tab
            AboutScreen()
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("About")
                }
        }
        .accentColor(.blue)
        .onAppear {
            #if canImport(UIKit)
            // Tab Bar Appearance Fix
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            #endif
        }
    }
}
