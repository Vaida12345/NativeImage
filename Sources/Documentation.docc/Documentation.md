# ``NativeImage``

Extended CoreGraphics functionalities & Native Image.

@Metadata {
    @PageColor(purple)
    
    @SupportedLanguage(swift)
    
    @Available(macOS,       introduced: 10.15)
    @Available(iOS,         introduced: 13.0)
    @Available(watchOS,     introduced:  6.0)
    @Available(tvOS,        introduced: 13.0)
    @Available(visionOS,    introduced:  1.0)
    @Available(macCatalyst, introduced: 13.0)
}

## Overview

This package comes with extended CoreGraphics functionalities & platform independent Image wrapper: ``NativeImage``


## Getting Started

`NativeImage` uses [Swift Package Manager](https://www.swift.org/documentation/package-manager/) as its build tool. If you want to import in your own project, it's as simple as adding a `dependencies` clause to your `Package.swift`:
```swift
dependencies: [
    .package(url: "https://github.com/Vaida12345/NativeImage.git", from: "1.0.0")
]
```
and then adding the appropriate module to your target dependencies.

### Using Xcode Package support

You can add this framework as a dependency to your Xcode project by clicking File -> Swift Packages -> Add Package Dependency. The package is located at:
```
https://github.com/Vaida12345/NativeImage
```


## Topics

### Interfaces

- ``NativeImage``

### Extended Functionalities

- <doc:CGImageEx>
