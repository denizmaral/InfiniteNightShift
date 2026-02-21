import SwiftUI

@main
struct InfiniteNightShiftApp: App {
    @StateObject private var nightShiftManager = NightShiftManager()
    @StateObject private var loginItemManager = LoginItemManager()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(
                nightShiftManager: nightShiftManager,
                loginItemManager: loginItemManager
            )
        } label: {
            Image(systemName: nightShiftManager.isPaused ? "moon" : "moon.fill")
        }
    }
}
