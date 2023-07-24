// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.



import PackageDescription

let package = Package(
    name: "USDTestingCLI",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .executable(
            name: "myusdtests",
            targets: ["USDTestingCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2"),
        .package(path: "../USDServiceProvider"),
    ],
    targets: [
        .executableTarget(
            name: "USDTestingCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "USDServiceProvider", package: "USDServiceProvider"),
            ]),
        .testTarget(
            name: "USDTestingCLITests",
            dependencies: ["USDTestingCLI"]),
    ]
)