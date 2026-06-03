import SwiftUI

struct InvasivePlant: Identifiable, Codable {
    let id: Int
    let region: String
    let scientificName: String
    let threatLabel: ThreatLabel
    let threatScore: Int
    let spreadRate: String
    let origin: String
    let appearance: String
    let impactSummary: String
    let bio: String
    let removalSteps: [String]
    let photoName: String

    enum ThreatLabel: String, Codable {
        case critical = "Critical"
        case high     = "High"
        case moderate = "Moderate"

        var color: Color {
            switch self {
            case .critical: return Color(red: 0.75, green: 0.22, blue: 0.17)
            case .high:     return Color(red: 0.90, green: 0.50, blue: 0.14)
            case .moderate: return Color(red: 0.95, green: 0.64, blue: 0.08)
            }
        }

        var label: String { rawValue.uppercased() }
    }

    var threatColor: Color { threatLabel.color }

    var citation: String {
        "Smithsonian Institution, Open Access Collection. Free to use under CC0 license. si.edu/openaccess"
    }

    static let all: [InvasivePlant] = {
        guard
            let url  = Bundle.main.url(forResource: "plants", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let list = try? JSONDecoder().decode([InvasivePlant].self, from: data)
        else { return [] }
        return list
    }()

    static func find(id: Int) -> InvasivePlant? {
        all.first { $0.id == id }
    }
}
