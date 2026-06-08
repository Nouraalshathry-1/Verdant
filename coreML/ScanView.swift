import SwiftUI
import AVFoundation

struct ScanView: View {
    @EnvironmentObject var store: ScanStore
    @EnvironmentObject var locationManager: LocationManager
    @State private var detectedPlant: InvasivePlant? = nil
    @State private var showCard = false
    @State private var navigateToDetail = false
    @State private var confidence: Double = 0.0
    @State private var isScanning = true
    @State private var isClassifying = false
    @State private var consecutiveCount = 0
    @State private var lastIdentifier = ""

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color("PrimaryColor").ignoresSafeArea()
                CameraPreviewView(onFrame: { pixelBuffer in
                    guard isScanning else { return }
                    guard !isTooDark(pixelBuffer) else {
                        consecutiveCount = 0
                        lastIdentifier = ""
                        return
                    }
                    classifyFrame(pixelBuffer)
                })

                if showCard, let plant = detectedPlant {
                    DetectionCardView(plant: plant, confidence: confidence) {
                        showCard = false
                        detectedPlant = nil
                        confidence = 0.0
                        consecutiveCount = 0
                        lastIdentifier = ""
                        isScanning = true
                    }
                    .onAppear {
                        let entry = ScanEntry(
                            plantID: plant.id,
                            confidence: confidence,
                            location: locationManager.locationString
                        )
                        store.add(entry)
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

    // Samples 25 pixels in a 5×5 grid. Returns true if the frame is too dark
    // to contain a visible plant (average luma < 30 out of 255).
    // Pixel format is kCVPixelFormatType_32BGRA so layout is [B, G, R, A].
    private func isTooDark(_ pixelBuffer: CVPixelBuffer) -> Bool {
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
        guard let base = CVPixelBufferGetBaseAddress(pixelBuffer) else { return true }
        let width  = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bpr    = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let buf    = base.assumingMemoryBound(to: UInt8.self)
        var total  = 0
        let xStep  = width  / 6
        let yStep  = height / 6
        for row in 1...5 {
            for col in 1...5 {
                let offset = (row * yStep) * bpr + (col * xStep) * 4
                let r = Int(buf[offset + 2])
                let g = Int(buf[offset + 1])
                let b = Int(buf[offset])
                total += (r + g + b) / 3
            }
        }
        return (total / 25) < 30
    }

    @MainActor
    func classifyFrame(_ pixelBuffer: CVPixelBuffer) {
        guard !isClassifying else { return }
        isClassifying = true
        PlantClassifier.shared.classify(pixelBuffer: pixelBuffer) { identifier, score in
            print("🔍 \(identifier) — \(Int(score * 100))%")
            Task { @MainActor in
                self.isClassifying = false
                guard score >= 0.92 else {
                    self.consecutiveCount = 0
                    self.lastIdentifier = ""
                    return
                }

                if identifier == self.lastIdentifier {
                    self.consecutiveCount += 1
                } else {
                    self.consecutiveCount = 1
                    self.lastIdentifier = identifier
                }
                guard self.consecutiveCount >= 3 else { return }

                guard let match = InvasivePlant.all.first(where: {
                    $0.scientificName == identifier
                }) else { return }
                self.consecutiveCount = 0
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
