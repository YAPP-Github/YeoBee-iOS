import ProjectDescription

let featureNameAttribute: Template.Attribute = .required("name")
let author: Template.Attribute = .required("author")
let currentDate: Template.Attribute = .required("currentDate")

let featureTemplate = Template(
    description: "Feature template",
    attributes: [
        featureNameAttribute,
        author,
        currentDate
    ],
    items: [
        .file(
            path: "\(featureNameAttribute)/Project.swift",
            templatePath: "FeatureProject.stencil"
        ),
        .file(
            path: "\(featureNameAttribute)/Sources/\(featureNameAttribute)ViewController.swift",
            templatePath: "FeatureViewController.stencil"
        ),
        .file(
            path: "\(featureNameAttribute)/Tests/\(featureNameAttribute)Tests.swift",
            templatePath: "FeatureTests.stencil"
        ),
        .file(
            path: "\(featureNameAttribute)/DemoApp/Sources/\(featureNameAttribute)AppDelegate.swift",
            templatePath: "FeatureDemoAppDelegate.stencil"
        )
        
    ]
)
