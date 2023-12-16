import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
  swiftPackageManager: SwiftPackageManagerDependencies(
    [
        .reactorKit,
    ],
    productTypes: [
      "ReactorKit": .framework,
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
