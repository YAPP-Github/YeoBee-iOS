import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
  swiftPackageManager: SwiftPackageManagerDependencies(
    [
        .moya,
        .reactorKit,
        .pinLayout,
        .flexLayout
    ],
    productTypes: [
      "Moya": .framework,
      "ReactorKit": .framework,
      "FlexLayout": .framework,
      "PinLayout": .framework,
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
