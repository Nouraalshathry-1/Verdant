import SwiftUI

struct ScanEntryRow: View {
    let entry: ScanEntry
    let plant: InvasivePlant

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: entry.date)
    }

    var body: some View {
        HStack(spacing: 14) {

            if let captured = entry.savedImage() {
                Image(uiImage: captured)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("AccentColor").opacity(0.2), lineWidth: 1)
                    )
            } else {
                Image(plant.photoName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("AccentColor").opacity(0.2), lineWidth: 1)
                    )
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(plant.scientificName)
                        .font(.system(size: 14, weight: .semibold))
                        .italic()
                        .foregroundColor(Color("AccentColor"))
                        .lineLimit(1)
                    Spacer()
                    ThreatBadgeView(label: plant.threatLabel)
                }

                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Color("AccentColor").opacity(0.5))
                    Text(entry.location)
                        .font(.system(size: 11))
                        .foregroundColor(Color("AccentColor").opacity(0.5))
                        .lineLimit(1)
                }

                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 10))
                        .foregroundColor(Color("AccentColor").opacity(0.5))
                    Text(formattedDate)
                        .font(.system(size: 11))
                        .foregroundColor(Color("AccentColor").opacity(0.5))
                }

                HStack(spacing: 12) {
                    Label("\(Int(entry.confidence * 100))% match", systemImage: "checkmark.seal.fill")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color("AccentColor").opacity(0.7))

                    Label(plant.spreadRate, systemImage: "arrow.triangle.branch")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color("AccentColor").opacity(0.7))
                }
            }
        }
        .padding(12)
        .background(Color("AccentColor").opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color("AccentColor").opacity(0.15), lineWidth: 1.5)
        )
    }
}
