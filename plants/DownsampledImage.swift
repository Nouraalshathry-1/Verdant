//
//  DownsampledImage.swift
//  Verdant
//
//  Created by Noura Alshathry on 03/06/2026.
//

import SwiftUI

/// Loads an asset-catalog image on a background thread, downsamples it to the
/// exact display pixels needed, and keeps only that small bitmap in memory.
/// A 6800×9000 museum photo (~230 MB) becomes ~1 MB at card size.
struct DownsampledImage: View {
    let name: String
    let size: CGSize

    @Environment(\.displayScale) private var displayScale
    @State private var uiImage: UIImage?

    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                Color.clear
            }
        }
        .task(id: name) {
            guard uiImage == nil else { return }
            let scale = displayScale
            let pixelSize = CGSize(width: size.width * scale, height: size.height * scale)
            uiImage = await Task.detached(priority: .userInitiated) {
                guard let full = UIImage(named: name) else { return nil }
                let format = UIGraphicsImageRendererFormat()
                format.scale = 1
                return UIGraphicsImageRenderer(size: pixelSize, format: format)
                    .image { _ in full.draw(in: CGRect(origin: .zero, size: pixelSize)) }
            }.value
        }
    }
}
