//
//  SwiftData.swift
//
//
//  Created by Vaida on 7/1/24.
//  Copyright © 2019 - 2024 Vaida. All rights reserved.
//

#if canImport(SwiftData)
import Foundation
import SwiftData


extension NativeImage {
    
    /// The value transformer to store a `NativeImage` within `SwiftData` `Model`.
    ///
    /// This transformer bridges between `NativeImage`, and being an attribute of a `Model`.
    ///
    /// ```swift
    /// @Attribute(.externalStorage, .transformable(by: NativeImage.ValueTransformer.name))
    /// var item: NativeImage
    /// ```
    ///
    /// The `heic` format is employed.
    ///
    /// ### Additional Setup
    ///
    /// To use this transformer, or any `ValueTransformer`, you must register it by defining the following in your main app
    /// ```swift
    /// init() {
    ///     NativeImage.ValueTransformer.register()
    /// }
    /// ```
    public final class ValueTransformer: Foundation.ValueTransformer {
        
        public override class func transformedValueClass() -> AnyClass {
            NativeImage.self
        }
        
        public override func transformedValue(_ value: Any?) -> Any? {
            let item = value as! NativeImage
            
            return try? item.data(format: .heic, quality: 0.9)
        }
        
        public override func reverseTransformedValue(_ value: Any?) -> Any? {
            let data = (value as! Data)
            return NativeImage(data: data)
        }
        
        public override class func allowsReverseTransformation() -> Bool {
            true
        }
        
        /// Register the transformer.
        ///
        /// You must register any `ValueTransformer` prior to its initial invocation.
        public static func register() {
            Foundation.ValueTransformer.setValueTransformer(NativeImage.ValueTransformer(), forName: .init(name))
        }
        
        /// The name of this transformer.
        ///
        /// Please use this name to direct `SwiftData` `Model` to the correct transformer.
        public static var name: String {
            "NativeImage.ValueTransformer"
        }
    }
    
}
#endif
