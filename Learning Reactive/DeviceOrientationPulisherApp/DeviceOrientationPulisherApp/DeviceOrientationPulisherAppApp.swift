//
//  DeviceOrientationPulisherAppApp.swift
//  DeviceOrientationPulisherApp
//
//  Created by dan phi on 12/02/2025.
//

import SwiftUI
import Combine
@main
struct DeviceOrientationPulisherAppApp: App {
    private var cancelables: Set<AnyCancellable> = []
    init () {
        NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification).sink { _ in
            let current = UIDevice.current.orientation
            print("haha \(current)")
        }.store(in: &cancelables)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
