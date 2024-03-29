import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let localHelper = LocalHelper(name: "MyPlugin")

let project = Project(
    name: "YeoBee",
    organizationName: "YeoBee.com",
    options: .options(
        automaticSchemesOptions: .disabled
    ),
    packages: [
    ],
    settings: .settings(configurations: [
        .debug(name: .debug, xcconfig: "./Secrets.xcconfig"),
        .release(name: .release, xcconfig: "./Secrets.xcconfig"),
    ]),
    targets: [
        Project.target(
            name: "YeoBee",
            product: .app,
            sources: "Sources/**",
            resources: "Resources/**",
            dependencies: [
                .sign,
                .expenditure,
                .home,
                .travelRegistration,
                .onboarding,
                .travleEdit,
                .expenditureEdit,
                .trip,
                .entity,
                .setting
            ],
            settings: .settings(base: [
                "ASSETCATALOG_COMPILER_APPICON_NAME":"AppIcon",
                "CODE_SIGN_ENTITLEMENTS": "YeoBee.entitlements",
                "OTHER_LDFLAGS": "$(inherited) -ObjC"
              ])
        ),
        Project.target(
            name: "YeoBeeTests",
            product: .unitTests,
            sources: "Tests/**",
            dependencies: [
                .yeoBee
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "YeoBeeDev",
            shared: true,
            buildAction: BuildAction(
                targets: ["YeoBee"]
            ),
            testAction: .targets(["YeoBeeTests"]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        Scheme(
            name: "YeoBeeProd",
            shared: true,
            buildAction: BuildAction(
                targets: ["YeoBee"]
            ),
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
