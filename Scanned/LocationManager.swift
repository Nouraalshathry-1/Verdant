//
//  LocationManager.swift
//  Verdant
//
//  Created by Noura Alshathry on 03/06/2026.
//




@preconcurrency import CoreLocation
@preconcurrency import MapKit
import Foundation

@MainActor
final class LocationManager: NSObject, ObservableObject {
    @Published var locationString: String = "Unknown Location"

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func start() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            break
        }
    }

    private func reverseGeocode(_ location: CLLocation) {
        Task {
            do {
                guard let request = MKReverseGeocodingRequest(location: location) else { return }
                let mapItems = try await request.mapItems
                guard let item = mapItems.first else { return }
                let placemark = item.placemark
                let parts = [placemark.locality, placemark.administrativeArea].compactMap { $0 }
                locationString = parts.isEmpty ? "Unknown Location" : parts.joined(separator: ", ")
            } catch {}
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            break
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Task { @MainActor [weak self] in
            self?.reverseGeocode(location)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}







//@preconcurrency import CoreLocation
//@preconcurrency import MapKit
//import Foundation
//
//@MainActor
//final class LocationManager: NSObject, ObservableObject {
//    @Published var locationString: String = "Unknown Location"
//
//    private let manager = CLLocationManager()
//
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyKilometer
//        manager.requestWhenInUseAuthorization()
//    }
//
//    private func reverseGeocode(_ location: CLLocation) {
//        Task {
//            do {
//                guard let request = MKReverseGeocodingRequest(location: location) else { return }
//                let mapItems = try await request.mapItems
//                guard let item = mapItems.first else { return }
//                let p = item.placemark
//                let parts = [p.locality, p.administrativeArea].compactMap { $0 }
//                locationString = parts.isEmpty ? "Unknown Location" : parts.joined(separator: ", ")
//            } catch {}
//        }
//    }
//}
//
//extension LocationManager: CLLocationManagerDelegate {
//    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch manager.authorizationStatus {
//        case .authorizedWhenInUse, .authorizedAlways:
//            manager.requestLocation()
//        default:
//            break
//        }
//    }
//
//    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        Task { @MainActor [weak self] in
//            self?.reverseGeocode(location)
//        }
//    }
//
//    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
//}


