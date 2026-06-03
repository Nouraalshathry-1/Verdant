import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .scan

    enum Tab {
        case discovered, scan, dictionary
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            DiscoveredView()
                .tabItem {
                    Label("Discovered", systemImage: "leaf.arrow.trianglehead.clockwise")
                }
                .tag(Tab.discovered)

            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "apple.meditate")
                }
                .tag(Tab.scan)

            DictionaryView()
                .tabItem {
                    Label("Dictionary", systemImage: "apple.meditate.square.stack")
                }
                .tag(Tab.dictionary)
        }
        .tint(Color("AccentColor"))
        .preferredColorScheme(.dark)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "PrimaryColor")

            let unselected = UITabBarItemAppearance()
            unselected.normal.iconColor = UIColor(named: "AccentColor")?.withAlphaComponent(0.4)
            unselected.normal.titleTextAttributes = [
                .foregroundColor: UIColor(named: "AccentColor")!.withAlphaComponent(0.4)
            ]

            appearance.stackedLayoutAppearance = unselected
            appearance.inlineLayoutAppearance = unselected
            appearance.compactInlineLayoutAppearance = unselected

            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
