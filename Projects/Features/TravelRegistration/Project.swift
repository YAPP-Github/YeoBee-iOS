import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "TravelRegistration",
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
            name: "TravelRegistration",
            product: .framework,
            sources: .sources,
            dependencies: [
                .designSystem,
                .RxSwift,
                .RxCocoa,
                .RxGesture,
                .reactorKit
            ]
        ),
        Project.target(
            name: "TravelRegistrationDemo",
            product: .app,
            sources: .demoSources,
            dependencies: [
                .target(name: "TravelRegistration")
            ]
        ),
        Project.target(
            name: "TravelRegistrationTests",
            product: .unitTests,
            sources: .tests,
            dependencies: [
                .target(name: "TravelRegistration")
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "TravelRegistrationDemo",
            shared: true,
            buildAction: BuildAction(
                targets: ["TravelRegistrationDemo"]
            ),
            testAction: .targets(["TravelRegistrationTests"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        Scheme(
            name: "TravelRegistration",
            shared: true,
            buildAction: BuildAction(
                targets: ["TravelRegistration"]
            ),
            testAction: .targets(["TravelRegistrationTests"]),
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
