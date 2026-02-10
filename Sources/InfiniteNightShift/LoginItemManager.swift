import Foundation
import ServiceManagement

@MainActor
final class LoginItemManager: ObservableObject {
    @Published var isEnabled: Bool {
        didSet {
            guard isEnabled != oldValue else { return }
            if isEnabled {
                try? SMAppService.mainApp.register()
            } else {
                try? SMAppService.mainApp.unregister()
            }
        }
    }

    private static let hasRegisteredKey = "hasRegisteredLoginItem"

    init() {
        let status = SMAppService.mainApp.status
        isEnabled = (status == .enabled)

        if !UserDefaults.standard.bool(forKey: Self.hasRegisteredKey) {
            UserDefaults.standard.set(true, forKey: Self.hasRegisteredKey)
            if status != .enabled {
                isEnabled = true
            }
        }
    }
}
