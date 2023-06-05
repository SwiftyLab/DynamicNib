// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "DynamicNibProvider",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.76.0"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [ .product(name: "Vapor", package: "vapor") ],
            exclude: [ "Xibs" ],
            resources: [.copy("Js")],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://www.swift.org/server/guides/building.html#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ],
            plugins: [ .plugin(name: "BuildNib") ]
        ),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ]),
        .plugin(name: "BuildNib", capability: .buildTool())
    ]
)
