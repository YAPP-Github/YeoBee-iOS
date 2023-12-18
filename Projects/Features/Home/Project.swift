import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Home",
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
            name: "Home",
            product: .framework,
            sources: .sources,
            dependencies: [
                .designSystem,
                .reactorKit,
                .flexLayout,
                .pinLayout
            ]
        ),
        Project.target(
            name: "HomeDemo",
            product: .app,
            sources: .demoSources,
            dependencies: [
                .target(name: "Home")
            ]
        ),
        Project.target(
            name: "HomeTests",
            product: .unitTests,
            sources: .tests,
            dependencies: [
                .target(name: "Home")
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "HomeDemo",
            shared: true,
            buildAction: BuildAction(
                targets: ["HomeDemo"]
            ),
            testAction: .targets(["HomeTests"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        Scheme(
            name: "Home",
            shared: true,
            buildAction: BuildAction(
                targets: ["Home"]
            ),
            testAction: .targets(["HomeTests"]),
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
