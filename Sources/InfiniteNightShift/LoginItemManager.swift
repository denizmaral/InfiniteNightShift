import AppKit
import Foundation
import os
import ServiceManagement

@MainActor
final class LoginItemManager: ObservableObject {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "InfiniteNightShift",
        category: "LoginItemManager"
    )

    @Published var isEnabled: Bool {
        didSet {
            guard isEnabled != oldValue else { return }
            updateRegistration(enabled: isEnabled)
        }
    }

    private static let hasRegisteredKey = "hasRegisteredLoginItem"

    init() {
        let status = SMAppService.mainApp.status
        Self.logger.info("Login item status: \(status.rawValue)")
        isEnabled = (status == .enabled)

        if !UserDefaults.standard.bool(forKey: Self.hasRegisteredKey) {
            UserDefaults.standard.set(true, forKey: Self.hasRegisteredKey)
            if status != .enabled {
                // didSet is not called during init, so register explicitly
                isEnabled = true
                updateRegistration(enabled: true)
            }
        }
    }

    private func updateRegistration(enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
                let actualStatus = SMAppService.mainApp.status
                Self.logger.info("Login item registered, actual status: \(actualStatus.rawValue)")

                if actualStatus == .requiresApproval {
                    Self.logger.info("Login item requires user approval in System Settings")
                    openLoginItemsSettings()
                }
            } else {
                try SMAppService.mainApp.unregister()
                Self.logger.info("Login item unregistered successfully")
            }
        } catch {
            Self.logger.error("Failed to \(enabled ? "register" : "unregister") login item: \(error)")
            // Revert UI state to match actual system state
            let actualStatus = SMAppService.mainApp.status
            isEnabled = (actualStatus == .enabled)
        }
    }

    private func openLoginItemsSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.LoginItems-Settings.extension") {
            NSWorkspace.shared.open(url)
        }
    }
}
