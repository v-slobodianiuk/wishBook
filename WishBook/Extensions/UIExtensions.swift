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
            .filter {$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged {_ in
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
    public func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
