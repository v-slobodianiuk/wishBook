//
//  BlurView.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 02.12.2021.
//

import UIKit
import SwiftUI

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    init(style: UIBlurEffect.Style = .systemMaterial) {
        self.style = style
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: self.style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: self.style)
    }
}
