import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "ExpenditureEdit",
    organizationName: "YeoBee.com",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    packages: [
    ],
    settings: .settings(configurations: [
        .debug(name: .debug),
        .release(name: .release),
    ]),
    targets: [
        Project.target(
            name: "ExpenditureEdit",
            product: .framework,
            sources: .sources,
            dependencies: [
                .designSystem,
                .RxSwift,
                .RxCocoa,
                .reactorKit,
                .composableArchitecture
            ]
        ),
        Project.target(
            name: "ExpenditureEditDemo",
            product: .app,
            sources: .demoSources,
            dependencies: [
                .expenditureEdit
            ]
        ),
        Project.target(
            name: "ExpenditureEditTests",
            product: .unitTests,
            sources: .tests,
            dependencies: [
                .target(name: "ExpenditureEdit")
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "ExpenditureEditDemo",
            shared: true,
            buildAction: BuildAction(
                targets: ["ExpenditureEditDemo"]
            ),
            testAction: .targets(["ExpenditureEditTests"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        Scheme(
            name: "ExpenditureEdit",
            shared: true,
            buildAction: BuildAction(
                targets: ["ExpenditureEdit"]
            ),
            testAction: .targets(["ExpenditureEditTests"]),
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
