import SwiftUI

struct MenuBarView: View {
    @ObservedObject var nightShiftManager: NightShiftManager
    @ObservedObject var loginItemManager: LoginItemManager

    var body: some View {
        Group {
            if !nightShiftManager.isSupported {
                Text("Night Shift not supported")
                    .foregroundStyle(.secondary)
            } else {
                Button(nightShiftManager.isPaused ? "Resume Enforcement" : "Pause Enforcement") {
                    nightShiftManager.isPaused.toggle()
                }

                Text(nightShiftManager.isPaused ? "Status: Paused" : "Status: Enforcing")
                    .foregroundStyle(.secondary)
            }

            Divider()

            Toggle("Launch at Login", isOn: $loginItemManager.isEnabled)

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
    }
}
