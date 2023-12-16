import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Feature template",
    attributes: [
        nameAttribute,
    ],
    items: [
        .file(
            path: "\(nameAttribute)/Project.swift",
            templatePath: "FeatureProject.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Sources/\(nameAttribute).swift",
            templatePath: "FeatureSource.stencil"
        ),
        .file(
            path: "\(nameAttribute)/Tests/\(nameAttribute)Tests.swift",
            templatePath: "FeatureTests.stencil"
        ),
        .file(
            path: "\(nameAttribute)/DemoApp/Sources/AppDelegate.swift",
            templatePath: "AppDelegate.stencil"
        )
        
    ]
)
