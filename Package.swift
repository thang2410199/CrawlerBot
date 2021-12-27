// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GiganttiBot",
    platforms: [
        .macOS(.v12),
        .iOS(.v13)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.0")),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.4"),
        .package(name: "TelegramBotSDK", url: "https://github.com/zmeyc/telegram-bot-swift.git", from: "2.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "GiganttiBot",
            dependencies: [
                "Alamofire",
                "SwiftSoup",
                "TelegramBotSDK"
            ],
            resources: [
                .copy("Resources/Catalog.json")
            ]
        ),
        .testTarget(
            name: "GiganttiBotTests",
            dependencies: ["GiganttiBot"]),
    ]
)
