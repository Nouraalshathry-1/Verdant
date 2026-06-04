import SwiftUI

struct DictionaryView: View {
    let saudiPlants = InvasivePlant.all.filter { $0.region == "SA" }
    let californiaPlants = InvasivePlant.all.filter { $0.region == "CA" }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("PrimaryColor").ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {

                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "🇸🇦 Saudi Arabia", subtitle: "Invaders of the Arabian Peninsula")

                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 14) {
                                    ForEach(saudiPlants) { plant in
                                        NavigationLink(destination: PlantDetailView(plant: plant)) {
                                            PlantCardView(plant: plant)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "🇺🇸 California", subtitle: "Invaders of the Golden State")

                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 14) {
                                    ForEach(californiaPlants) { plant in
                                        NavigationLink(destination: PlantDetailView(plant: plant)) {
                                            PlantCardView(plant: plant)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Dictionary")
                        .font(.headline)
                        .foregroundColor(Color("AccentColor"))
                }
            }
            .toolbarBackground(Color("PrimaryColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct SectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(Color("AccentColor"))
            Text(subtitle)
                .font(.caption)
                .foregroundColor(Color("AccentColor").opacity(0.5))
        }
        .padding(.horizontal, 16)
    }
}
