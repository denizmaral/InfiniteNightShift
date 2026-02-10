import Foundation
import CoreBrightnessShim

@MainActor
final class NightShiftManager: ObservableObject {
    @Published var isPaused = false {
        didSet {
            if isPaused {
                stopEnforcing()
            } else {
                startEnforcing()
            }
        }
    }

    @Published private(set) var isSupported = true

    private let client = CBBlueLightClient()
    private var timer: Timer?

    init() {
        guard CBBlueLightClient.supportsBlueLightReduction() else {
            isSupported = false
            return
        }
        startEnforcing()
    }

    private func startEnforcing() {
        enableNightShift()
        registerNotificationBlock()
        startPollingTimer()
    }

    private func stopEnforcing() {
        timer?.invalidate()
        timer = nil
        client.setStatusNotificationBlock(nil)
    }

    private func enableNightShift() {
        client.setEnabled(true)
    }

    private func registerNotificationBlock() {
        client.setStatusNotificationBlock { [weak self] in
            Task { @MainActor in
                self?.onStatusChanged()
            }
        }
    }

    private func onStatusChanged() {
        guard !isPaused else { return }

        var status = StatusData()
        client.getBlueLightStatus(&status)

        if status.enabled == 0 {
            enableNightShift()
        }
    }

    private func startPollingTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.onStatusChanged()
            }
        }
    }

    deinit {
        timer?.invalidate()
    }
}
