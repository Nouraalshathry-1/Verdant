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
        .tint(.white)
        .preferredColorScheme(.dark)
    }
}
