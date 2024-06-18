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
    
    /// Render the view to given destination.
    ///
    /// ## Rendering
    /// The following components will cause the result to be rendered in `TIFF`!
    /// - `material`
    ///
    /// - Parameters:
    ///   - destination: The destination
    ///   - format: The resulting format
    ///   - scale: The scale to the view
    @inlinable
    @MainActor
    func render(to destination: URL, format: NativeImage.ImageFormatOption = .pdf, scale: Double = 1) {
        let renderer = ImageRenderer(content: self)
        if format == .pdf {
            renderer.render { size, render in
                var mediaBox = CGRect(origin: .zero, size: size.scaled(by: scale))
                guard let consumer = CGDataConsumer(url: destination as CFURL),
                      let pdfContext =  CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else { return }
                pdfContext.beginPDFPage(nil)
                pdfContext.scaleBy(x: scale, y: scale)
                render(pdfContext)
                pdfContext.endPDFPage()
                pdfContext.closePDF()
            }
        } else {
            renderer.scale = scale
            try? renderer.cgImage?.write(to: destination, format: format)
        }
    }
    
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
