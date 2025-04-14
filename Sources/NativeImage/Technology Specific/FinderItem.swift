//
//  FinderItem.swift
//  GraphicsKit
//
//  Created by Vaida on 9/26/24.
//

import FinderItem
import SwiftUI
#if !os(tvOS) && !os(watchOS)
import QuickLookThumbnailing
#endif


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
    func render(to destination: FinderItem, format: NativeImage.ImageFormatOption = .pdf, scale: Double = 2) {
        let renderer = ImageRenderer(content: self)
        if format == .pdf {
            renderer.render { size, render in
                var mediaBox = CGRect(origin: .zero, size: size.scaled(by: scale))
                guard let consumer = CGDataConsumer(url: destination.url as CFURL),
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
}


public extension CGImage {
    
    /// Write a `CGImage` as in the format of `option` to the `destination`.
    ///
    /// A `quality` value of 1.0 specifies to use lossless compression if destination format supports it. A value of 0.0 implies to use maximum compression.
    ///
    /// - Parameters:
    ///   - destination: The `FinderItem` representing the path to save the image.
    ///   - format: The format of the image, pass `nil` to auto infer from the extension name of `destination`.
    ///   - quality: The image compression quality.
    func write(to destination: FinderItem, format: NativeImage.ImageFormatOption? = nil, quality: CGFloat = 1) throws {
        do {
            let _option = format != nil ? format! : try NativeImage.ImageFormatOption.inferredFrom(extension: destination.extension)
            let imageData = try self.data(format: _option, quality: quality)
            
            try imageData.write(to: destination)
        } catch {
            throw try FinderItem.FileError.parse(orThrow: error)
        }
    }
    
}


public extension FinderItem.LoadableContent {
    
    /// Returns the image at the location, if exists.
    static var image: FinderItem.LoadableContent<NativeImage, any Error> {
        .init { (source: FinderItem) throws -> NativeImage in
            guard source.isFile else {
                throw FinderItem.FileError(code: .cannotRead(reason: .corruptFile), source: source)
            }
            let data = try Data(at: source)
            if let image = NativeImage(data: data) {
                return image
            } else {
                throw FinderItem.FileError(code: .cannotRead(reason: .corruptFile), source: source)
            }
        }
    }
    
    /// Returns the image at the location, if exists.
    static var cgImage: FinderItem.LoadableContent<CGImage, any Error> {
        .init { (source: FinderItem) throws -> CGImage in
            try self.image.contentLoader(source).cgImage!
        }
    }
    
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
    /// Returns the icon at the location.
    ///
    /// The resulting image is scaled down to the required `size`.
    ///
    /// - Parameters:
    ///   - size: The size of the image.
    ///
    /// - Returns: If the file does not exist, or no representations larger than `size`, returns nil.
    static func icon(size: CGSize? = nil) -> FinderItem.LoadableContent<NativeImage, any Error> {
        .init { (source: FinderItem) throws -> NativeImage in
            guard source.exists else { throw FinderItem.FileError(code: .cannotRead(reason: .noSuchFile), source: source) }
            let icons = NSWorkspace.shared.icon(forFile: source.path)
            
            guard let size else { return icons }
            
            if let first = icons.representations.first(where: { CGFloat($0.pixelsHigh) >= size.height && CGFloat($0.pixelsWide) >= size.width }),
               let image = first.cgImage(forProposedRect: nil, context: nil, hints: nil),
               let scaled = image.resized(to: image.size.aspectRatio(.fit, in: size)) {
                return NativeImage(cgImage: scaled)
            } else {
                throw FinderItem.FileError(code: .cannotRead(reason: .corruptFile), source: source)
            }
        }
    }
#endif
}

public extension FinderItem.AsyncLoadableContent {
    
#if !os(tvOS) && !os(watchOS)
    private static func generateImage(type: QLThumbnailGenerator.Request.RepresentationTypes, url: URL, size: CGSize) async throws -> (NativeImage, QLThumbnailRepresentation.RepresentationType) {
        let result = try await QLThumbnailGenerator.shared.generateBestRepresentation(for: .init(fileAt: url, size: size, scale: 1, representationTypes: type))
        
#if os(macOS)
        return (result.nsImage, result.type)
#elseif os(iOS) || os(visionOS)
        return (result.uiImage, result.type)
#endif
    }
    
    /// Generate the preview image for the given source.
    ///
    /// - Parameters:
    ///   - size: The size of the image.
    ///
    /// - Returns: If the file does not exist, or no representations larger than `size`, returns nil.
    static func preview(size: CGSize) -> FinderItem.AsyncLoadableContent<NativeImage, any Error> {
        .init { source in
            guard source.exists else { throw FinderItem.FileError(code: .cannotRead(reason: .noSuchFile), source: source) }
            do {
                return try await generateImage(type: .thumbnail, url: source.url, size: size).0
            } catch {
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
                do {
                    return try source.load(.icon(size: size))
                } catch {}
#endif
                return try await generateImage(type: .icon, url: source.url, size: size).0
            }
        }
    }
#endif
    
}
