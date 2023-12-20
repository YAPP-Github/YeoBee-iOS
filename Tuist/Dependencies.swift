import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
  swiftPackageManager: SwiftPackageManagerDependencies(
    [
        .moya,
        .reactorKit,
        .pinLayout,
        .flexLayout,
        .fscalendar
    ],
    productTypes: [
      "Moya": .framework,
      "ReactorKit": .framework,
      "FlexLayout": .framework,
      "PinLayout": .framework,
      "FSCalendar": .framework
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
