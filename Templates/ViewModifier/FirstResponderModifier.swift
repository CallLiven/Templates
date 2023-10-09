//
//  FirstResponderModifier.swift
//  Templates
//
//  Created by Liven on 2023/10/8.
//

import SwiftUI
import AppKit

struct FirstResponderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(FirstResponderFinder())
    }
}

extension View {
    func firstResponder() -> some View {
        self.modifier(FirstResponderModifier())
    }
}

struct FirstResponderFinder: NSViewRepresentable {
    class Coordinator: NSObject {
        var view: NSView?
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        context.coordinator.view = view
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            if let view = context.coordinator.view,
               let textView = view.superview?.subviews.compactMap({ $0 as? NSTextField }).first {
                textView.window?.makeFirstResponder(textView)
            }
        }
    }
}
