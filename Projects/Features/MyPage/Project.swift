import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "MyPage",
    organizationName: "YeoBee.com",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    packages: [],
    settings: .settings(configurations: [
        .debug(name: .debug),
        .release(name: .release),
    ]),
    targets: [
        Project.target(
            name: "MyPage",
            product: .framework,
            sources: .sources,
            dependencies: [
                .designSystem,
                .RxSwift,
                .RxCocoa,
                .reactorKit,
                .kingfisher
            ]
        ),
        Project.target(
            name: "MyPageDemo",
            product: .app,
            sources: .demoSources,
            dependencies: [
                .target(name: "MyPage")
            ]
        ),
        Project.target(
            name: "MyPageTests",
            product: .unitTests,
            sources: .tests,
            dependencies: [
                .target(name: "MyPage")
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "MyPageDemo",
            shared: true,
            buildAction: BuildAction(
                targets: ["MyPageDemo"]
            ),
            testAction: .targets(["MyPageTests"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        Scheme(
            name: "MyPage",
            shared: true,
            buildAction: BuildAction(
                targets: ["MyPage"]
            ),
            testAction: .targets(["MyPageTests"]),
            runAction: .runAction(configuration: .release),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release),
            analyzeAction: .analyzeAction(configuration: .release)
        )
    ],
    fileHeaderTemplate: nil,
    additionalFiles: [],
    resourceSynthesizers: []
)
