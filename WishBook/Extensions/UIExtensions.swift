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

struct ResignKeyboardOnTapGesture: ViewModifier {
    
    var action: Closure?
    
    func gesture() -> _EndedGesture<TapGesture> {
        TapGesture().onEnded { _ in
            UIApplication.shared.endEditing(true)
            action?()
        }
    }
    
    func body(content: Content) -> some View {
        content.gesture(gesture())
    }
}

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
    
    func resignKeyboardOnTapGesture(action: Closure? = nil) -> some View {
        return modifier(ResignKeyboardOnTapGesture(action: action))
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
