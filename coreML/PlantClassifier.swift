@preconcurrency import Vision
import CoreML
import UIKit

@MainActor
final class PlantClassifier: @unchecked Sendable {
    static let shared = PlantClassifier()
    private var request: VNCoreMLRequest?

    private init() {
        do {
            guard let modelURL = Bundle.main.url(forResource: "PlantClassifier", withExtension: "mlmodelc") else {
                print("❌ PlantClassifier.mlmodelc not found in bundle")
                return
            }
            let config = MLModelConfiguration()
            let coreMLModel = try MLModel(contentsOf: modelURL, configuration: config)
            let vnModel = try VNCoreMLModel(for: coreMLModel)
            request = VNCoreMLRequest(model: vnModel)
            request?.imageCropAndScaleOption = .centerCrop
            print("✅ Model loaded successfully")
        } catch {
            print("❌ Failed to load model: \(error)")
        }
    }

    func classify(pixelBuffer: CVPixelBuffer, completion: @escaping @Sendable (String, Double) -> Void) {
        guard let request = request else { return }
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
            guard let top = (request.results as? [VNClassificationObservation])?.first else { return }
            DispatchQueue.main.async {
                completion(top.identifier, Double(top.confidence))
            }
        }
    }
}
