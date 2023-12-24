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
            name: "DesignSystemDemo",
            product: .app,
            sources: .demoSources,
            dependencies: [
                .designSystem
            ]
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
            name: "DesignSystemDemo",
            shared: true,
            buildAction: BuildAction(
                targets: ["DesignSystemDemo"]
            ),
            testAction: .targets(["DesignSystemTests"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        Scheme(
            name: "DesignSystem",
            shared: true,
            buildAction: BuildAction(
                targets: ["DesignSystem"]
            ),
            testAction: .targets(["DesignSystemTests"]),
            runAction: .runAction(configuration: .release),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release),
            analyzeAction: .analyzeAction(configuration: .release)
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

