import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Trip",
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
            name: "Trip",
            product: .staticFramework,
            sources: .sources,
            dependencies: [
                .designSystem,
                .RxSwift,
                .RxCocoa,
                .reactorKit,
                .coordinator,
                .expenditure
            ]
        ),
        Project.target(
            name: "TripDemo",
            product: .app,
            sources: .demoSources,
            dependencies: [
                .trip
            ]
        ),
        Project.target(
            name: "TripTests",
            product: .unitTests,
            sources: .tests,
            dependencies: [
                .trip
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "TripDemo",
            shared: true,
            buildAction: BuildAction(
                targets: ["TripDemo"]
            ),
            testAction: .targets(["TripTests"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        Scheme(
            name: "Trip",
            shared: true,
            buildAction: BuildAction(
                targets: ["Trip"]
            ),
            testAction: .targets(["TripTests"]),
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
