import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "TravelEdit",
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
            name: "TravelEdit",
            product: .framework,
            sources: .sources,
            dependencies: [
                .designSystem,
                .RxSwift,
                .RxCocoa,
                .reactorKit,
                .flexLayout,
                .pinLayout,
                .fscalendar
            ]
        ),
        Project.target(
            name: "TravelEditDemo",
            product: .app,
            sources: .demoSources,
            dependencies: [
                .target(name: "TravelEdit")
            ]
        ),
        Project.target(
            name: "TravelEditTests",
            product: .unitTests,
            sources: .tests,
            dependencies: [
                .target(name: "TravelEdit")
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "TravelEditDemo",
            shared: true,
            buildAction: BuildAction(
                targets: ["TravelEditDemo"]
            ),
            testAction: .targets(["TravelEditTests"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        Scheme(
            name: "TravelEdit",
            shared: true,
            buildAction: BuildAction(
                targets: ["TravelEdit"]
            ),
            testAction: .targets(["TravelEditTests"]),
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
