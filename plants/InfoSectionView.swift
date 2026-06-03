import SwiftUI

struct InfoSectionView<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(iconColor)
                Text(title)
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundColor(Color("AccentColor").opacity(0.5))
                    .textCase(.uppercase)
                    .kerning(1.2)
            }

            content()
        }
    }
}
