//
//  TextView.swift
//  WishBook
//
//  Created by Вадим on 10.05.2021.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    
    private let textView = UITextView()
    @Binding var text: String
    
    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UITextView {
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<TextView>) {
        uiView.text = text
    }
    
    func makeCoordinator() -> TextView.Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        private let textView: TextView

        init(_ textView: TextView) {
            self.textView = textView
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.textView.text = textView.text
        }
    }
}

extension TextView {
    func isScrollEnabled(_ isScrollEnabled: Bool) -> Self {
        textView.isScrollEnabled = isScrollEnabled
        return self
    }
    
    func isEditable(_ isEditable: Bool) -> Self {
        textView.isEditable = isEditable
        return self
    }
    
    func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        textView.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }
    
    func font(_ font: UIFont?) -> Self {
        textView.font = font
        return self
    }
    
    func backgroundColor(_ backgroundColor: UIColor?) -> Self {
        textView.backgroundColor = backgroundColor
        return self
    }
    
    func textColor(_ textColor: UIColor?) -> Self {
        textView.textColor = textColor
        return self
    }
    
    func setBorder(borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat = 0) -> Self {
        textView.layer.borderColor = borderColor.cgColor
        textView.layer.borderWidth = borderWidth
        textView.layer.cornerRadius = cornerRadius
        return self
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView(text: .constant("Description"))
            .font(.systemFont(ofSize: 25, weight: .medium))
            .backgroundColor(.systemGreen)
            .textColor(.white)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 70)
            .cornerRadius(5)
            .padding()
    }
}
