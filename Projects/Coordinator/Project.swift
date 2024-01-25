import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Coordinator",
    organizationName: "YeoBee.com",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    packages: [],
    settings: nil,
    targets: [
        Project.target(
            name: "Coordinator",
            product: .framework,
            sources: "Sources/**",
            dependencies: [
                .entity
            ]
        ),
        Project.target(
            name: "CoordinatorTests",
            product: .unitTests,
            sources: "Tests/**",
            dependencies: [
                .target(name: "Coordinator")
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "Coordinator",
            shared: true,
            buildAction: BuildAction(
                targets: ["Coordinator"]
            ),
            testAction: .targets(["CoordinatorTests"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        )
    ],
    fileHeaderTemplate: nil,
    additionalFiles: [],
    resourceSynthesizers: []
)
