# Migration Guide

## 1.x -> 2.x

Gauntlet 2.0 includes a complete rethink of the APIs. To allow for a smooth and gradual transition to the new APIs the old APIs continue to exist, but have been moved to a new target `GauntletLegacy`. This was done to allow the old APIs to remain unchanged so that any tests using the old Gauntlet APIs can continue to run unaffected, and migrated to the new APIs over time.

### Updating the Package Dependency

First you'll need to update your package dependency to point to Gauntlet 2.0.0. After this you'll need to update your project to reference both the `Gauntlet` and `GauntletLegacy` targets. The process for this differs based on whether you're integrating into an App or a Framework with a Package file.

#### Apps

After updating to Gauntlet 2.0.0 navigate to your test target and select the Build Phases tab. Here you'll add the `GauntletLegacy` target to the Link Binary With Libraries phase, in addition to the `Gauntlet` target it should already be linking.

#### Frameworks

For a framework that uses a `Package.swift` file you'll need to update the dependencies section to link against both targets. Below is an example of a package's `testTarget` linking against both Gauntlet targets.

```Swift
.testTarget(
    name: "MyFrameworkTests",
    dependencies: [
        "MyFramework",
        .product(name: "Gauntlet", package: "Gauntlet"),
        .product(name: "GauntletLegacy", package: "Gauntlet")
    ],
)
```

### Updating Imports

Now that you're linking against the new target you'll nee to update exiting imports in your unit tests. Any code that imported `Gauntlet` should now import `GauntletLegacy` instead, as that target contains all of the old APIs. This should be the only change needed to get your tests building and running as they did previously. A find and replace of `import Gauntlet` to `import GauntletLegacy` across the project will be the easiest way to make this change.
