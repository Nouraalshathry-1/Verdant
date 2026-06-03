import SwiftUI

struct PlantDetailView: View {
    let plant: InvasivePlant

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                Image(plant.photoName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .clipped()

                VStack(alignment: .leading, spacing: 24) {

                    VStack(alignment: .leading, spacing: 8) {
                        Text(plant.scientificName)
                            .font(.system(size: 26, weight: .bold))
                            .italic()
                            .foregroundColor(Color("AccentColor"))

                        HStack(spacing: 12) {
                            Text(plant.threatLabel.label)
                                .font(.system(size: 11, weight: .heavy))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(plant.threatLabel.color)                                .clipShape(Capsule())

                            Text(plant.region == "SA" ? "🇸🇦 Saudi Arabia" : "🇺🇸 California")
                                .font(.system(size: 13))
                                .foregroundColor(Color("AccentColor").opacity(0.6))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Threat Score")
                                    .font(.caption)
                                    .foregroundColor(Color("AccentColor").opacity(0.6))
                                Spacer()
                                Text("\(plant.threatScore) / 100")
                                    .font(.caption.bold())
                                    .foregroundColor(plant.threatColor)
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 99)
                                        .fill(Color("AccentColor").opacity(0.15))
                                        .frame(height: 8)
                                    RoundedRectangle(cornerRadius: 99)
                                        .fill(plant.threatColor)
                                        .frame(
                                            width: geo.size.width * CGFloat(plant.threatScore) / 100,
                                            height: 8
                                        )
                                }
                            }
                            .frame(height: 8)
                        }
                    }

                    Divider()
                        .background(Color("AccentColor").opacity(0.2))

                    InfoSectionView(
                        title: "Impact",
                        icon: "exclamationmark.triangle.fill",
                        iconColor: plant.threatColor
                    ) {
                        Text(plant.impactSummary)
                            .font(.subheadline)
                            .foregroundColor(Color("AccentColor").opacity(0.85))
                    }

                    Divider()
                        .background(Color("AccentColor").opacity(0.2))

                    InfoSectionView(
                        title: "Origin",
                        icon: "globe",
                        iconColor: Color("AccentColor")
                    ) {
                        Text(plant.origin)
                            .font(.subheadline)
                            .foregroundColor(Color("AccentColor").opacity(0.85))
                    }

                    Divider()
                        .background(Color("AccentColor").opacity(0.2))

                    InfoSectionView(
                        title: "Appearance",
                        icon: "leaf.fill",
                        iconColor: Color("AccentColor")
                    ) {
                        Text(plant.appearance)
                            .font(.subheadline)
                            .foregroundColor(Color("AccentColor").opacity(0.85))
                            .lineSpacing(4)
                    }

                    Divider()
                        .background(Color("AccentColor").opacity(0.2))

                    InfoSectionView(
                        title: "About",
                        icon: "text.alignleft",
                        iconColor: Color("AccentColor")
                    ) {
                        Text(plant.bio)
                            .font(.subheadline)
                            .foregroundColor(Color("AccentColor").opacity(0.85))
                            .lineSpacing(4)
                    }

                    Divider()
                        .background(Color("AccentColor").opacity(0.2))

                    InfoSectionView(
                        title: "How to Remove",
                        icon: "hand.raised.fill",
                        iconColor: Color("AccentColor")
                    ) {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(Array(plant.removalSteps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: 12) {
                                    // Step number
                                    Text("\(index + 1)")
                                        .font(.system(size: 12, weight: .heavy))
                                        .foregroundColor(Color("PrimaryColor"))
                                        .frame(width: 24, height: 24)
                                        .background(Color("AccentColor"))
                                        .clipShape(Circle())

                                    Text(step)
                                        .font(.subheadline)
                                        .foregroundColor(Color("AccentColor").opacity(0.85))
                                        .lineSpacing(4)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }

                    Divider()
                        .background(Color("AccentColor").opacity(0.2))

                    InfoSectionView(
                        title: "Image Source",
                        icon: "photo.fill",
                        iconColor: Color("AccentColor").opacity(0.6)
                    ) {
                        Text(plant.citation)
                            .font(.caption)
                            .foregroundColor(Color("AccentColor").opacity(0.5))
                            .lineSpacing(3)
                    }
                }
                .padding(20)
            }
        }
        .background(Color("PrimaryColor").ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonView()
                    .padding(.top, 8)
            }
        }
    }
}
