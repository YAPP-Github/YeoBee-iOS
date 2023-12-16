import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
  swiftPackageManager: SwiftPackageManagerDependencies(
    [
      .remote(
        url: "https://github.com/airbnb/lottie-ios",
        requirement: .exact("3.2.3")
      ),
    ],
    productTypes: [
      "Lottie": .framework,
    ],
    baseSettings: .settings(
      configurations: [
        .debug(name: .debug),
        .release(name: .release)
      ]
    )
  ),
  platforms: [.iOS]
)
