import TapestryDescription

let config = TapestryConfig(
    release: Release(
        actions: [
            .pre(.docsUpdate),
            .pre(.dependenciesCompatibility([.cocoapods, .carthage, .spm(.all)]))
        ],
        add: [
            "README.md",
            "OpenGoogleSignInSDK.podspec",
            "CHANGELOG.md"
        ],
        commitMessage: "🔖 Version \(Argument.version)",
        push: false
    )
)
