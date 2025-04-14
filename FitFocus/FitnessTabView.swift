//
//  FitnessTabView.swift
//  FitFocus
//
//  Created by Eugene Obazee on 14/04/2025.
//

import SwiftUI

struct FitnessTabView: View {
    @State var selectedTab = "Home"
    
    init(selectedTab: String = "Home") {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.stackedLayoutAppearance.selected.iconColor = .green
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label]
        
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab){
            HomeView()
                .tag("Home")
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
            
            HistoricDataView()
                .tag("Historic")
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Charts")
                }
        }
    }
}

struct FitnessTabView_Previews: PreviewProvider {
    static var previews: some View {
        FitnessTabView()
    }
}
