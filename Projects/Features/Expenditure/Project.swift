import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Expenditure",
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
            name: "Expenditure",
            product: .framework,
            sources: .sources,
            dependencies: [
                .RxGesture,
                .designSystem,
                .RxSwift,
                .RxCocoa,
                .reactorKit
            ]
        ),
        Project.target(
            name: "ExpenditureDemo",
            product: .app,
            sources: .demoSources,
            dependencies: [
                .expenditure
            ]
        ),
        Project.target(
            name: "ExpenditureTests",
            product: .unitTests,
            sources: .tests,
            dependencies: [
                .expenditure
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "ExpenditureDemo",
            shared: true,
            buildAction: BuildAction(
                targets: ["ExpenditureDemo"]
            ),
            testAction: .targets(["ExpenditureTests"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        Scheme(
            name: "Expenditure",
            shared: true,
            buildAction: BuildAction(
                targets: ["Expenditure"]
            ),
            testAction: .targets(["ExpenditureTests"]),
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
