//
//  UIExtensions.swift
//  WishBook
//
//  Created by Vadym on 29.03.2021.
//

import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

extension UIImage {
    func downsample(to pointSize: CGSize, scale: CGFloat?) -> UIImage {
        
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        //let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions)!
        let imageSource = CGImageSourceCreateWithData(self.pngData()! as CFData, imageSourceOptions)!

        let maxDimensionInPixels: CGFloat
        
        if let scale = scale {
            maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        } else {
            maxDimensionInPixels = max(pointSize.width, pointSize.height) * traitCollection.displayScale
        }

        let downsampleOptions =
            [kCGImageSourceCreateThumbnailFromImageAlways: true,
             kCGImageSourceShouldCacheImmediately: true,
             kCGImageSourceCreateThumbnailWithTransform: true,
             kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        
        let downsampledImage =
            CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
        return UIImage(cgImage: downsampledImage)
    }
}
