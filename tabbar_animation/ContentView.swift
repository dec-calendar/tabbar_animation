//
//  ContentView.swift
//  tabbar_animation
//
//  Created by 大澤清乃 on 2024/12/03.
//

import SwiftUI

@Observable
class NavigationHelper: NSObject {
    var path: NavigationPath = .init()
    var popProgress: CGFloat = 1.0
}

struct ContentView: View {
    var navigationHelper: NavigationHelper = .init()
    var body: some View {
        VStack {
            @Bindable var bindableHelper = navigationHelper
            NavigationStack(path: $bindableHelper.path) {
                List {
                    Button {
                        navigationHelper.path.append("test")
                    } label: {
                        Text("test")
                            .foregroundStyle(Color.primary)
                    }
                }
                .navigationTitle("Home")
                .navigationDestination(for: String.self) { navTitle in
                    Text("Post's View")
                        .navigationTitle(navTitle)
                }
            }
            CustomButtomBar()
        }
        .environment(navigationHelper)
        .padding()
    }
}

struct CustomButtomBar: View {
    @Environment(NavigationHelper.self) private var navigationHelper
    @State private var selectedTab: TabModel = .home
    var body: some View {
        HStack(spacing: 0) {
            let blur = (1 - navigationHelper.popProgress) * 3
            let scale = (1 - navigationHelper.popProgress) * 0.1
            ForEach(TabModel.allCases, id: \.rawValue) { tab in
                Button {
                    if tab == .newPost {
                        
                    } else {
                        selectedTab = tab
                    }
                } label: {
                    Image(systemName: tab.rawValue)
                        .font(.title3)
                        .foregroundStyle(selectedTab == tab ? Color.primary : Color.gray)
                        .blur(radius: tab != .newPost ? blur : 0)
                        .scaleEffect(tab == .newPost ? 1.5 : 1 - scale)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .contentShape(.rect)
                }
                .opacity(tab != .newPost ? navigationHelper.popProgress : 1)
                .overlay {
                    ZStack {
                        if tab == .home {
                            Button {
                                
                            } label: {
                                Image(systemName: "exclamationmark.bubble")
                                    .font(.title3)
                                    .foregroundStyle(Color.primary)
                            }
                        }
                        
                        if tab == .settings {
                            Button {
                                
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.title3)
                                    .foregroundStyle(Color.primary)
                            }
                        }
                    }
                    .opacity(1 - navigationHelper.popProgress)
                }
            }
        }
        .onChange(of: navigationHelper.path) { oldValue, newValue in
            if newValue.count > oldValue.count {
                navigationHelper.popProgress = 0.0
            } else {
                navigationHelper.popProgress = 1.0
            }
        }
        .animation(.easeInOut(duration: 0.25), value: navigationHelper.popProgress)
    }
}

enum TabModel: String, CaseIterable {
    case home = "house.fill"
    case search = "magnifyingglass"
    case newPost = "square.and.pencil.circle.fill"
    case notifications = "bell.fill"
    case settings = "gearshape.fill"
}

#Preview {
    ContentView()
}
