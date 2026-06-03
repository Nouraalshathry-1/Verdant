import SwiftUI

struct DiscoveredView: View {
    @EnvironmentObject var store: ScanStore

    var body: some View {
        NavigationStack {
            ZStack {
                Color("PrimaryColor").ignoresSafeArea()

                if store.entries.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(store.entries) { entry in
                                if let plant = InvasivePlant.find(id: entry.plantID) {
                                    NavigationLink(destination: PlantDetailView(plant: plant)) {
                                        ScanEntryRow(entry: entry, plant: plant)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Discovered")
                        .font(.headline)
                        .foregroundColor(Color("AccentColor"))
                }
            }
            .toolbarBackground(Color("PrimaryColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }

    var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "leaf.arrow.trianglehead.clockwise")
                .font(.system(size: 44))
                .foregroundColor(Color("AccentColor").opacity(0.3))
            Text("No plants discovered yet")
                .font(.headline)
                .foregroundColor(Color("AccentColor").opacity(0.6))
            Text("Go to Scan and point your camera at a plant")
                .font(.subheadline)
                .foregroundColor(Color("AccentColor").opacity(0.35))
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}
