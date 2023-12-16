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
            product: .staticLibrary,
            sources: .sources,
            resources: "Resources/**"
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
    fileHeaderTemplate: nil,
    additionalFiles: [],
    resourceSynthesizers: []
)
