import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            .RxSwift,
            .moya,
            .reactorKit,
            .fscalendar
        ],
        productTypes: [
            "RxSwift": .framework,
            "RxCocoa": .framework,
            "Moya": .framework,
            "ReactorKit": .framework,
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
