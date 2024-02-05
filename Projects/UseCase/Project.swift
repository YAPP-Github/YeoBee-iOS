import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "UseCase",
    organizationName: "YeoBee.com",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    packages: [],
    settings: nil,
    targets: [
        Project.target(
            name: "UseCase",
            product: .framework,
            sources: "Sources/**",
            dependencies: [
                .repository,
                .composableArchitecture
            ]
        ),
        Project.target(
            name: "UseCaseTests",
            product: .unitTests,
            sources: "Tests/**",
            dependencies: [
                .usecase
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "UseCase",
            shared: true,
            buildAction: BuildAction(
                targets: ["UseCase"]
            ),
            testAction: .targets(["UseCaseTests"]),
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
