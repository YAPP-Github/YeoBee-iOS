import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Setting",
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
            name: "Setting",
            product: .staticFramework,
            sources: .sources,
            dependencies: [
                .designSystem,
                .RxSwift,
                .RxCocoa,
                .reactorKit,
                .travelRegistration,
                .fscalendar,
                .kingfisher
            ]
        ),
        Project.target(
            name: "SettingDemo",
            product: .app,
            sources: .demoSources,
            dependencies: [
                .target(name: "Setting")
            ]
        ),
        Project.target(
            name: "SettingTests",
            product: .unitTests,
            sources: .tests,
            dependencies: [
                .target(name: "Setting")
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "SettingDemo",
            shared: true,
            buildAction: BuildAction(
                targets: ["SettingDemo"]
            ),
            testAction: .targets(["SettingTests"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        Scheme(
            name: "Setting",
            shared: true,
            buildAction: BuildAction(
                targets: ["Setting"]
            ),
            testAction: .targets(["SettingTests"]),
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
