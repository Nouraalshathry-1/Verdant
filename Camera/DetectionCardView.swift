import SwiftUI

struct DetectionCardView: View {
    let plant: InvasivePlant
    let confidence: Double
    let onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 99)
                    .fill(Color("AccentColor").opacity(0.4))
                    .frame(width: 36, height: 4)
                Spacer()
            }

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plant.scientificName)
                        .font(.title3.bold())
                        .italic()
                        .foregroundColor(Color("AccentColor"))
                }
                Spacer()
                Text("\(Int(confidence * 100))% match")
                    .font(.caption.bold())
                    .foregroundColor(Color("PrimaryColor"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color("AccentColor"))
                    .clipShape(Capsule())
            }

            Divider()
                .background(Color("AccentColor").opacity(0.2))

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Threat Score")
                        .font(.caption)
                        .foregroundColor(Color("AccentColor").opacity(0.6))
                    Spacer()
                    Text("\(plant.threatScore)/100")
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
                            .frame(width: geo.size.width * CGFloat(plant.threatScore) / 100, height: 8)
                    }
                }
                .frame(height: 8)
            }

            HStack {
                Image(systemName: "arrow.triangle.branch")
                    .foregroundColor(Color("AccentColor").opacity(0.6))
                    .font(.caption)
                Text("Spreads \(plant.spreadRate)")
                    .font(.caption)
                    .foregroundColor(Color("AccentColor").opacity(0.8))
                Spacer()
                Text("Tap for details →")
                    .font(.caption2.bold())
                    .foregroundColor(Color("AccentColor").opacity(0.5))
            }
        }
        .padding(20)
        .background(Color("PrimaryColor"))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color("AccentColor").opacity(0.25), lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
        .overlay(alignment: .topTrailing) {
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color("AccentColor").opacity(0.4))
                    .font(.title3)
                    .padding(16)
            }
        }
    }
}
