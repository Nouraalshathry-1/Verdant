import Foundation
import UIKit

struct ScanEntry: Identifiable, Codable {
    let id: UUID
    let plantID: Int
    let confidence: Double
    let date: Date
    let location: String
    let photoFileName: String?

    init(plantID: Int, confidence: Double, location: String = "Unknown Location", photoFileName: String? = nil) {
        self.id = UUID()
        self.plantID = plantID
        self.confidence = confidence
        self.date = Date()
        self.location = location
        self.photoFileName = photoFileName
    }

    func savedImage() -> UIImage? {
        guard let fileName = photoFileName else { return nil }
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    static func saveImage(_ image: UIImage) -> String? {
        let fileName = UUID().uuidString + ".jpg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        try? data.write(to: url)
        return fileName
    }
}
