//
//  NativeImage.swift
//
//
//  Created by Vaida on 4/7/22.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif


#if canImport(AppKit) && !targetEnvironment(macCatalyst)
/// An interface for manipulating image data.
///
/// These are the additional functionalities given to `NativeImage` in addition to `NSImage`.
///
/// - Note: The value is `NSImage` for macOS and `UIImage` for iOS / iPadOS
public typealias NativeImage = NSImage
#elseif canImport(UIKit)
/// An interface for manipulating image data.
///
/// These are the additional functionalities given to `NativeImage` in addition to `NSImage`.
///
/// - Note: The value is `NSImage` for macOS and `UIImage` for iOS / iPadOS
public typealias NativeImage = UIImage
#endif


#if canImport(AppKit) && !targetEnvironment(macCatalyst)
public extension NativeImage {
    
    /// The underlying Quartz image data.
    @inlinable
    var cgImage: CGImage? {
        self.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    
    /// Initializes and returns the image object with the specified Quartz image reference.
    @inlinable
    convenience init(cgImage: CGImage) {
        self.init(cgImage: cgImage, size: cgImage.size)
    }
    
}
#elseif canImport(UIKit)
public extension NativeImage { }
#endif
