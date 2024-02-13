import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            .RxSwift,
            .moya,
            .reactorKit,
            .fscalendar,
            .RxGesture,
            .composableArchitecture,
            .SnapKit,
            .kingfisher,
            .kakaoLogin
        ],
        productTypes: [
            "RxSwift": .framework,
            "RxCocoa": .framework,
            "Moya": .framework,
            "ReactorKit": .framework,
            "FSCalendar": .framework,
            "RxGesture": .framework,
            "ComposableArchitecture": .framework,
            "Snapkit": .framework,
            "Kingfisher": .framework,
            "kakaoSDKAuth": .framework,
            "kakaoSDKUser": .framework
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
