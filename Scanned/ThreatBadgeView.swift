import SwiftUI

struct ThreatBadgeView: View {
    let label: InvasivePlant.ThreatLabel

    var body: some View {
        Text(label.label)
            .font(.system(size: 10, weight: .heavy))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(label.color)
            .clipShape(Capsule())
    }
}
