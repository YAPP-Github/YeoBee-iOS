import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Entity",
    organizationName: "YeoBee.com",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    packages: [],
    settings: nil,
    targets: [
        Project.target(
            name: "Entity",
            product: .staticFramework,
            sources: "Sources/**",
            dependencies: []
        )
    ],
    schemes: [
        Scheme(
            name: "Entity",
            shared: true,
            buildAction: BuildAction(
                targets: ["Entity"]
            ),
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
