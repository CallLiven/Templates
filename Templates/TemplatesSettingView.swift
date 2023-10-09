//
//  TemplatesSettingView.swift
//  Templates
//
//  Created by Liven on 2023/10/7.
//

import SwiftUI
import CodeHighlighter

struct TemplatesSettingView: View {
    @Binding var fileContent: String
    
    var body: some View {
        CodeTextView(
            fileContent,
            language: "swift",
            lightTheme: .solarizedLight,
            darkTheme: .solarizedDark)
    }
}

struct TemplatesSettingView_Previews: PreviewProvider {
    static var previews: some View {
        TemplatesSettingView(fileContent: .constant("test.py"))
    }
}
