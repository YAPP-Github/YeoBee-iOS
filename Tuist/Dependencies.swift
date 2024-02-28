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
            .kakaoLogin,
            .firebase
        ],
        productTypes: [
            "RxSwift": .staticFramework,
            "RxCocoa": .staticFramework,
            "Moya": .staticFramework,
            "ReactorKit": .staticFramework,
            "FSCalendar": .staticFramework,
            "RxGesture": .staticFramework,
            "ComposableArchitecture": .staticFramework,
            "Snapkit": .staticFramework,
            "Kingfisher": .staticFramework,
            "kakaoSDKAuth": .staticFramework,
            "kakaoSDKUser": .staticFramework,
            "FirebaseAnalytics" : .staticFramework
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
