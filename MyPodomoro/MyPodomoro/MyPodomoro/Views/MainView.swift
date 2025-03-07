//
//  MainView.swift
//  MyPodomoro
//
//  Created by admin on 2024/1/1.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            PodomoroListView()
                .tabItem {
                    Image(systemName: "house")
                    Text("首页")
                }
                .tag(1)
                .background(selectedTab == 1 ? Color.blue : Color.clear)

            USER()
                .tabItem {
                    Image(systemName: "person")
                    Text("用户")
                }
                .tag(2)
                .background(selectedTab == 2 ? Color.blue : Color.clear)
        }
    }
}

#Preview {
    MainView()
}
