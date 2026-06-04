


import SwiftUI

@main
struct VerdantApp: App {
    @StateObject var store = ScanStore()
    @StateObject var locationManager = LocationManager()

    init() {
        // Pure liquid glass pill with white icons — no custom background.
        let item = UITabBarItemAppearance()
        item.normal.iconColor   = UIColor.white.withAlphaComponent(0.5)
        item.selected.iconColor = UIColor.white
        item.normal.titleTextAttributes   = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        item.selected.titleTextAttributes = [.foregroundColor: UIColor.white]

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.stackedLayoutAppearance       = item
        appearance.inlineLayoutAppearance        = item
        appearance.compactInlineLayoutAppearance = item

        UITabBar.appearance().standardAppearance   = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(store)
                .environmentObject(locationManager)
                .task { locationManager.start() }
        }
    }
}



//import SwiftUI
//
//@main
//struct VerdantApp: App {
//    @StateObject var store = ScanStore()
//    @StateObject var locationManager = LocationManager()
//
//    init() {
//        // Pure liquid glass pill with white icons — no custom background.
//        let item = UITabBarItemAppearance()
//        item.normal.iconColor   = UIColor.white.withAlphaComponent(0.5)
//        item.selected.iconColor = UIColor.white
//        item.normal.titleTextAttributes   = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
//        item.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
//
//        let appearance = UITabBarAppearance()
//        appearance.configureWithTransparentBackground()
//        appearance.stackedLayoutAppearance       = item
//        appearance.inlineLayoutAppearance        = item
//        appearance.compactInlineLayoutAppearance = item
//
//        UITabBar.appearance().standardAppearance   = appearance
//        UITabBar.appearance().scrollEdgeAppearance = appearance
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            MainTabView()
//                .environmentObject(store)
//                .environmentObject(locationManager)
//        }
//    }
//}
