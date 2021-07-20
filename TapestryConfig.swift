import TapestryDescription

let config = TapestryConfig(
    release: Release(
        actions: [
            .pre(.docsUpdate),
            .pre(.dependenciesCompatibility([
                .cocoapods,
                // Cannot use Carthage check because
                // we need to run carthage.sh or `--use-xcframeworks`.
                // Will be resolved in the future
                // .carthage,
                .spm(.all)
            ]))
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
