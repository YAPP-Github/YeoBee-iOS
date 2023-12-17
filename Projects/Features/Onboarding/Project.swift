import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Onboarding",
    organizationName: "YeoBee.com",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    packages: [],
    settings: .settings(configurations: [
        .debug(name: .debug),
        .release(name: .release),
    ]),
    targets: [
        Project.target(
            name: "Onboarding",
            product: .framework,
            sources: .sources,
            dependencies: [
                .designSystem
            ]
        ),
        Project.target(
            name: "OnboardingDemo",
            product: .app,
            sources: .demoSources,
            dependencies: [
                .target(name: "Onboarding")
            ]
        ),
        Project.target(
            name: "OnboardingTests",
            product: .unitTests,
            sources: .tests,
            dependencies: [
                .target(name: "Onboarding")
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "OnboardingDemo",
            shared: true,
            buildAction: BuildAction(
                targets: ["OnboardingDemo"]
            ),
            testAction: .targets(["OnboardingTests"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        Scheme(
            name: "Onboarding",
            shared: true,
            buildAction: BuildAction(
                targets: ["Onboarding"]
            ),
            testAction: .targets(["OnboardingTests"]),
            runAction: .runAction(configuration: .release),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release),
            analyzeAction: .analyzeAction(configuration: .release)
        )
    ],
    fileHeaderTemplate: nil,
    additionalFiles: [],
    resourceSynthesizers: []
)
