// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Gauntlet",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macCatalyst(.v13),
        .macOS(.v10_15),
        .watchOS(.v6)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "Gauntlet", targets: ["Gauntlet"]),
        .library(name: "GauntletLegacy", targets: ["GauntletLegacy"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Gauntlet",
            dependencies: [],
            swiftSettings:
                [
                    .enableExperimentalFeature("StrictConcurrency")
                ]
        ),
        .target(name: "GauntletLegacy", dependencies: []),
        .testTarget(
            name: "GauntletTests",
            dependencies: ["Gauntlet"],
            swiftSettings:
                [
                    .enableExperimentalFeature("StrictConcurrency")
                ]
        ),
        .testTarget(
            name: "GauntletLegacyTests",
            dependencies: ["GauntletLegacy"],
            swiftSettings:
                [
                    .enableExperimentalFeature("StrictConcurrency")
                ]
        )
    ]
)
