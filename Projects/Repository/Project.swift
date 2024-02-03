import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Repository",
    organizationName: "YeoBee.com",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    packages: [],
    settings: nil,
    targets: [
        Project.target(
            name: "Repository",
            product: .framework,
            sources: "Sources/**",
            dependencies: [
                .network,
                .entity
            ]
        ),
        Project.target(
            name: "RepositoryTests",
            product: .unitTests,
            sources: "Tests/**",
            dependencies: [
                .repository
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "Repository",
            shared: true,
            buildAction: BuildAction(
                targets: ["Repository"]
            ),
            testAction: .targets(["RepositoryTests"]),
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
