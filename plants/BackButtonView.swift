import SwiftUI

struct BackButtonView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "arrow.backward")
                Text("Back")
            }
            .foregroundColor(Color("AccentColor"))
            .fontWeight(.semibold)
        }
    }
}
