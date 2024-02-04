import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "YBDependency",
    organizationName: "YeoBee.com",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    packages: [],
    settings: nil,
    targets: [
        Project.target(
            name: "YBDependency",
            product: .framework,
            sources: "Sources/**",
            dependencies: [
                .composableArchitecture,
                .usecase
            ]
        ),
        Project.target(
            name: "YBDependencyTests",
            product: .unitTests,
            sources: "Tests/**",
            dependencies: [
                .ybdependency            ]
        )
    ],
    schemes: [
        Scheme(
            name: "YBDependency",
            shared: true,
            buildAction: BuildAction(
                targets: ["YBDependency"]
            ),
            testAction: .targets(["YBDependencyTests"]),
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
