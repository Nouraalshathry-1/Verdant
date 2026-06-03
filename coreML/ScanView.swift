

import SwiftUI
import AVFoundation

struct ScanView: View {
    @EnvironmentObject var store: ScanStore
    @State private var detectedPlant: InvasivePlant? = nil
    @State private var showCard = false
    @State private var navigateToDetail = false
    @State private var confidence: Double = 0.0
    @State private var isScanning = true

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                CameraPreviewView(onFrame: { pixelBuffer in
                    guard isScanning else { return }
                    classifyFrame(pixelBuffer)
                })

                if showCard, let plant = detectedPlant {
                    DetectionCardView(plant: plant, confidence: confidence) {
                        let entry = ScanEntry(plantID: plant.id, confidence: confidence)
                        store.add(entry)
                        showCard = false
                        detectedPlant = nil
                        confidence = 0.0
                        isScanning = true
                    }
                    .onTapGesture { navigateToDetail = true }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 16)
                    .padding(.horizontal, 16)
                    .navigationDestination(isPresented: $navigateToDetail) {
                        if let plant = detectedPlant {
                            PlantDetailView(plant: plant)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text("Find the Invader")
                            .font(.headline)
                            .foregroundColor(Color("AccentColor"))
                        Text("Point your camera at a plant")
                            .font(.caption2)
                            .foregroundColor(Color("AccentColor").opacity(0.6))
                    }
                }
            }
            .toolbarBackground(Color("PrimaryColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }

    @MainActor
    func classifyFrame(_ pixelBuffer: CVPixelBuffer) {
        PlantClassifier.shared.classify(pixelBuffer: pixelBuffer) { identifier, score in
            print("🔍 \(identifier) — \(Int(score * 100))%")
            Task { @MainActor in
                guard score >= 0.75 else { return }
                guard let match = InvasivePlant.all.first(where: {
                    $0.scientificName == identifier
                }) else { return }
                self.detectedPlant = match
                self.confidence = score
                self.isScanning = false
                withAnimation(.spring(duration: 0.5)) {
                    self.showCard = true
                }
            }
        }
    }
}
