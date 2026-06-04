@preconcurrency import Vision
import CoreML
import UIKit

@MainActor
final class PlantClassifier: @unchecked Sendable {
    static let shared = PlantClassifier()
    private var vnModel: VNCoreMLModel?
    private let classifyQueue = DispatchQueue(label: "plantClassifier", qos: .userInitiated)

    private init() {
        do {
            guard let modelURL = Bundle.main.url(forResource: "PlantClassifier", withExtension: "mlmodelc") else {
                print("❌ PlantClassifier.mlmodelc not found in bundle")
                return
            }
            let config = MLModelConfiguration()
            let coreMLModel = try MLModel(contentsOf: modelURL, configuration: config)
            vnModel = try VNCoreMLModel(for: coreMLModel)
            print("✅ Model loaded successfully")
        } catch {
            print("❌ Failed to load model: \(error)")
        }
    }

    func classify(pixelBuffer: CVPixelBuffer, completion: @escaping @Sendable (String, Double) -> Void) {
        guard let vnModel else { return }
        // CVPixelBuffer is a C type with no Sendable conformance; wrapping it lets us
        // cross the concurrency boundary safely — AVFoundation guarantees the buffer
        // stays valid until the VNImageRequestHandler finishes.
        struct SendableBuffer: @unchecked Sendable { let value: CVPixelBuffer }
        let sendable = SendableBuffer(value: pixelBuffer)
        classifyQueue.async {
            let request = VNCoreMLRequest(model: vnModel)
            request.imageCropAndScaleOption = .centerCrop
            let handler = VNImageRequestHandler(cvPixelBuffer: sendable.value, options: [:])
            try? handler.perform([request])
            guard let top = (request.results as? [VNClassificationObservation])?.first else { return }
            DispatchQueue.main.async {
                completion(top.identifier, Double(top.confidence))
            }
        }
    }
}
