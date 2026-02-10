// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "InfiniteNightShift",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .target(
            name: "CoreBrightnessShim",
            path: "Sources/CoreBrightnessShim",
            publicHeadersPath: "include"
        ),
        .executableTarget(
            name: "InfiniteNightShift",
            dependencies: ["CoreBrightnessShim"],
            path: "Sources/InfiniteNightShift",
            exclude: ["Info.plist"],
            swiftSettings: [
                .unsafeFlags([
                    "-Fsystem", "/System/Library/PrivateFrameworks"
                ])
            ],
            linkerSettings: [
                .unsafeFlags([
                    "-F", "/System/Library/PrivateFrameworks",
                    "-framework", "CoreBrightness",
                    "-Xlinker", "-sectcreate",
                    "-Xlinker", "__TEXT",
                    "-Xlinker", "__info_plist",
                    "-Xlinker", "Sources/InfiniteNightShift/Info.plist"
                ])
            ]
        )
    ]
)
