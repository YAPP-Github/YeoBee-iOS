import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "YBNetwork",
    organizationName: "YeoBee.com",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    packages: [],
    settings: nil,
    targets: [
        Project.target(
            name: "YBNetwork",
            product: .framework,
            sources: "Sources/**",
            dependencies: [
                .moya
            ]
        ),
        Project.target(
            name: "YBNetworkTests",
            product: .unitTests,
            sources: "Tests/**",
            dependencies: [
                .ybnetwork
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "YBNetwork",
            shared: true,
            buildAction: BuildAction(
                targets: ["YBNetwork"]
            ),
            testAction: .targets(["YBNetworkTests"]),
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
