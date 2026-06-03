
import SwiftUI

struct PlantCardView: View {
    let plant: InvasivePlant

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Photo
            ZStack(alignment: .topTrailing) {
                Image(plant.photoName)
                    .resizable()
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
                    .foregroundColor(Color("AccentColor"))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                Text(plant.spreadRate)
                    .font(.system(size: 10))
                    .foregroundColor(Color("AccentColor").opacity(0.5))
            }
            .padding(10)
            .frame(width: 160, alignment: .leading)
        }
        .frame(width: 160)
        .background(Color("PrimaryColor"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color("AccentColor").opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
    }
}
