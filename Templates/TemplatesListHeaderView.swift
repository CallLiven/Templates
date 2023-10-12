//
//  TemplatesListHeaderView.swift
//  Templates
//
//  Created by Liven on 2023/10/9.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    var key: String
    var value: String
}

struct TemplatesListHeaderView: View {
    @State private var items: [Item] = []

    var body: some View {
        VStack(spacing: 0) {
            ProjectRootFolderPath()
            SectionHeaderView()
            List {
                ForEach(items.indices, id: \.self) { index in
                    ItemRow(item: $items[index])
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
    }
    
    private func addParamItem() {
        items.append(Item(key: "", value: ""))
    }
}

extension TemplatesListHeaderView {
    @ViewBuilder
    func SectionHeaderView() -> some View {
        HStack {
            Text("模版全局参数")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16)
                .foregroundColor(.accentColor)
                .onTapGesture {
                    addParamItem()
                }
        }.padding(.bottom, 12)
    }
    
    @ViewBuilder
    func ProjectRootFolderPath() -> some View {
        VStack {
            Text("项目根目录")
                .font(.title3)
                .foregroundColor(.secondary)
                .padding(.bottom, 8)
                .hSpacing(.leading)
            
            Text("请选择项目根目录文件夹授权")
                .padding(.vertical, 8)
                .font(.body)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)  // 设置frame
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                )
                .padding(.horizontal, 8)
                .padding(.bottom, 16)
            
        }
        .padding(.bottom, 12)
    }
}

struct ItemRow: View {
    @Binding var item: Item
    @State private var isKeyEditing = false
    @State private var isValueEditing = false
    
    var body: some View {
        VStack(spacing: 6) {
            // Key
            if isKeyEditing {
                HStack {
                    Text("Key:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .hSpacing(.leading)
                        .frame(width: 70)
                    FocusedTextField("Enter Key", text: $item.key, keepFirstResponder: .constant(false), onCommit: {
                        isKeyEditing = false
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2) {
                        isKeyEditing = true
                    }
                }
            } else {
                HStack {
                    Text("Key:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .hSpacing(.leading)
                        .frame(width: 70)
                    Spacer()
                    Text("\(item.key)")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .contentShape(Rectangle())
                .onTapGesture(count: 2) {
                    isKeyEditing = true
                }
            }
            
            // Value
            if isValueEditing {
                HStack {
                    Text("Value:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .hSpacing(.leading)
                        .frame(width: 70)
                    FocusedTextField("Enter value", text: $item.value, keepFirstResponder: .constant(false), onCommit: {
                        isValueEditing = false
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2) {
                        isValueEditing = true
                    }
                }
            } else {
                HStack {
                    Text("Value:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .hSpacing(.leading)
                        .frame(width: 70)
                    Spacer()
                    Text("\(item.value)")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .contentShape(Rectangle())
                .onTapGesture(count: 2) {
                    isValueEditing = true
                }
            }
            Divider()
        }
    }
}


struct TemplatesListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TemplatesListHeaderView()
    }
}
