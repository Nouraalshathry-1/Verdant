import Foundation

@MainActor
class ScanStore: ObservableObject {
    @Published var entries: [ScanEntry] = []
    private let key = "scan_entries"

    init() {
        load()
    }

    func add(_ entry: ScanEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let saved = try? JSONDecoder().decode([ScanEntry].self, from: data)
        else { return }
        entries = saved
    }
}
