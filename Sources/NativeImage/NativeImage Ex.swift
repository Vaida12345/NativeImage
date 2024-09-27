//
//  NativeImage Extensions.swift
//
//
//  Created by Vaida on 4/13/22.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

import SwiftUI


public extension Image {
    
    /// Creates a SwiftUI image from an Native image instance.
    @inlinable
    init(nativeImage: NativeImage) {
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
        self.init(nsImage: nativeImage)
#elseif canImport(UIKit)
        self.init(uiImage: nativeImage)
#endif
    }
    
}

public extension Image {
    
    /// Creates a SwiftUI image from an Native image instance.
    init(cgImage: CGImage) {
        self.init(nativeImage: NativeImage(cgImage: cgImage))
    }
    
}


@available(macOS 13, iOS 16.0, tvOS 16.0, watchOS 9, *)
public extension View {
    
    /// Render the view.
    ///
    /// - Important: The returned image is **always** bitmap image, to render a `pdf`, use `render(to:format:scale:)` instead.
    ///
    /// - Parameters:
    ///   - scale: The scale to the view
    @inlinable
    @MainActor
    func render(scale: Double = 1) -> CGImage? {
        let renderer = ImageRenderer(content: self)
        
        renderer.scale = scale
        return renderer.cgImage
    }
}
