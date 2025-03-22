// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "TemperatureTracker",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TemperatureTracker",
            targets: ["TemperatureTracker"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TemperatureTracker",
            dependencies: [],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .define("INFO_PLIST_PATH", to: "Resources/Info.plist")
            ]
        )
    ]
)