//
//  BlurView.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 02.12.2021.
//

import UIKit
import SwiftUI

struct BlurView: UIViewRepresentable {
    
    private let visualEffectView = UIVisualEffectView()
    let style: UIBlurEffect.Style
    
    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIVisualEffectView {
        visualEffectView.effect = UIBlurEffect(style: style)
        return visualEffectView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<BlurView>) { }
}
