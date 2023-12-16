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
            sources: "Sources/**",
            resources: "Resources/**"
        ),
        Project.target(
            name: "DesignSystemTests",
            product: .unitTests,
            sources: "Tests/**",
            dependencies: [
                .target(name: "DesignSystem")
            ]
        )
    ],
    fileHeaderTemplate: nil,
    additionalFiles: [],
    resourceSynthesizers: []
)
