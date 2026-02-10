import SwiftUI

@main
struct InfiniteNightShiftApp: App {
    @StateObject private var nightShiftManager = NightShiftManager()
    @StateObject private var loginItemManager = LoginItemManager()

    var body: some Scene {
        MenuBarExtra(
            "Infinite Night Shift",
            systemImage: nightShiftManager.isPaused ? "moon.slash" : "moon.fill"
        ) {
            MenuBarView(
                nightShiftManager: nightShiftManager,
                loginItemManager: loginItemManager
            )
        }
    }
}
