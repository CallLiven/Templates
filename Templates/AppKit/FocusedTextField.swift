//
//  FocusedTextField.swift
//  Templates
//
//  Created by Liven on 2023/10/8.
//

import SwiftUI
import AppKit

struct FocusedTextField: NSViewRepresentable {
    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: FocusedTextField
        
        init(parent: FocusedTextField) {
            self.parent = parent
        }
        
        func controlTextDidChange(_ obj: Notification) {
            if let textField = obj.object as? NSTextField {
//                self.parent.keepFirstResponder = false
                self.parent.text = textField.stringValue
            }
        }
        
        func controlTextDidEndEditing(_ obj: Notification) {
            parent.onCommit()
        }
    }
    
    @Binding var text: String
    @Binding var keepFirstResponder: Bool
    var title: String
    var onCommit: () -> Void
    
    public init(_ title: String, text: Binding<String>, keepFirstResponder: Binding<Bool>, onCommit: @escaping () -> Void = {}) {
        self.title = title
        self._text = text
        self._keepFirstResponder = keepFirstResponder
        self.onCommit = onCommit
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    /**
     在 SwiftUI 中，每次视图的状态发生变化时（例如，当用户输入文本时），updateNSView 方法都会被调用。
     这意味着每次用户输入字符时，你都在尝试将文本字段设置为第一响应者，可能会导致文本字段失去焦点并
     立即重新获取焦点，从而触发 controlTextDidEndEditing(_:) 方法
     
     为了解决这个问题，你可以尝试将设置第一响应者的逻辑移到 makeNSView(context:) 方法中，
     以确保只在创建文本字段时尝试设置第一响应者
     */
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.placeholderString = title
        textField.delegate = context.coordinator
        DispatchQueue.main.async {
            if let window = textField.window, !window.makeFirstResponder(textField) {
                print("Failed to make text field first responder")
            }
        }
        return textField
    }
    
    /**
     有一种场景是这样的，比如当输入框的内容超过限制的条件，会弹出Alert提现用户
     当用户点击Alert的“确定”按钮的时候，希望能够将输入框变成第一响应者
     所以添加了一个条件：keepFirstResponder
     */
    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
        if keepFirstResponder {
            DispatchQueue.main.async {
                if let window = nsView.window, !window.makeFirstResponder(nsView) {
                    print("Failed to make text field first responder")
                }
            }
        }
    }
}
