import PackageDescription

let package = Package(
    name: "Graffeine",
    products: [
        .library(name: "Graffeine", targets: ["Graffeine"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Graffeine", dependencies: []),
        .testTarget(name: "GraffeineTests", dependencies: ["Graffeine"]),
    ]
)
