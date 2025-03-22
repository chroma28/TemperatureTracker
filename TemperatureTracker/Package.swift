// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "TemperatureTracker",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "TemperatureTracker",
            targets: ["TemperatureTracker"]),
    ],
    dependencies: [
        // No external dependencies required at this time
    ],
    targets: [
        .target(
            name: "TemperatureTracker",
            dependencies: [],
            path: "Sources/TemperatureTracker",
            resources: [.process("Resources")]
        )
    ]
)