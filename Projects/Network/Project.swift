import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Network",
    organizationName: "YeoBee.com",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    packages: [],
    settings: nil,
    targets: [
        Project.target(
            name: "Network",
            product: .staticLibrary,
            sources: "Sources/**",
            dependencies: [
                .moya
            ]
        ),
        Project.target(
            name: "NetworkTests",
            product: .unitTests,
            sources: "Tests/**",
            dependencies: [
                .network
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "Network",
            shared: true,
            buildAction: BuildAction(
                targets: ["Network"]
            ),
            testAction: .targets(["NetworkTests"]),
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
