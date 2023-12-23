import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "DesignSystem",
    organizationName: "YeoBee.com",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    packages: [],
    settings: nil,
    targets: [
        Project.target(
            name: "DesignSystem",
            product: .framework,
            sources: .sources,
            resources: ResourceFileElements(
                resources: [
                  .glob(pattern: .relativeToRoot("Projects/DesignSystem/Resources/**")),
                  .glob(pattern: .relativeToRoot("Projects/DesignSystem/Resources/Font/**"))
                ]
              )
        ),
        Project.target(
            name: "DesignSystemTests",
            product: .unitTests,
            sources: .tests,
            dependencies: [
                .designSystem
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "DesignSystem",
            shared: true,
            buildAction: BuildAction(
                targets: ["DesignSystem"]
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
    resourceSynthesizers: [
      .strings(),
      .assets(),
      .fonts()
    ]
)
