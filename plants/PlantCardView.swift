
import SwiftUI

struct PlantCardView: View {
    let plant: InvasivePlant

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Photo
            ZStack(alignment: .topTrailing) {
                DownsampledImage(name: plant.photoName, size: CGSize(width: 160, height: 200))
                    .scaledToFill()
                    .frame(width: 160, height: 200)
                    .clipped()

                ThreatBadgeView(label: plant.threatLabel)
                    .padding(8)
            }

            // Name
            VStack(alignment: .leading, spacing: 4) {
                Text(plant.scientificName)
                    .font(.system(size: 12, weight: .semibold))
                    .italic()
                    .foregroundColor(Color("PrimaryColor"))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                Text(plant.spreadRate)
                    .font(.system(size: 10))
                    .foregroundColor(Color("PrimaryColor").opacity(0.7))
            }
            .padding(10)
            .frame(width: 160, alignment: .leading)
            .background(Color("AccentColor"))
        }
        .frame(width: 160)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color("AccentColor").opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
    }
}
