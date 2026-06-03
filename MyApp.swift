import SwiftUI

@main
struct VerdantApp: App {
    @StateObject var store = ScanStore()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(store)
        }
    }
}
