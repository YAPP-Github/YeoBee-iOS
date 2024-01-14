import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Sign",
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
            name: "Sign",
            product: .framework,
            sources: .sources,
            dependencies: [
                .designSystem,
                .RxSwift,
                .RxCocoa,
                .reactorKit,
                .coordinator
            ]
        ),
        Project.target(
            name: "SignDemo",
            product: .app,
            sources: .demoSources,
            dependencies: [
                .sign
            ]
        ),
        Project.target(
            name: "SignTests",
            product: .unitTests,
            sources: .tests,
            dependencies: [
                .sign
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "SignDemo",
            shared: true,
            buildAction: BuildAction(
                targets: ["SignDemo"]
            ),
            testAction: .targets(["SignTests"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        Scheme(
            name: "Sign",
            shared: true,
            buildAction: BuildAction(
                targets: ["Sign"]
            ),
            testAction: .targets(["SignTests"]),
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
