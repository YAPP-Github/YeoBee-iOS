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
    fileHeaderTemplate: nil,
    additionalFiles: [],
    resourceSynthesizers: []
)
