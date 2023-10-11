//
//  TemplatesListHeaderView.swift
//  Templates
//
//  Created by Liven on 2023/10/9.
//

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let key: String
    var value: String
}

struct TemplatesListHeaderView: View {
    @State private var items: [Item] = []

    var body: some View {
        VStack(spacing: 0) {
            sectionHeaderView()
            List {
                ForEach(items.indices, id: \.self) { index in
                    ItemRow(item: $items[index])
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 12)
    }
    
    @ViewBuilder
    func sectionHeaderView() -> some View {
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
    func paramItemView(key: String, value: String?) -> some View {
        VStack(spacing: 6) {
            HStack {
                Text("Key:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
                TextField(key, text: .constant(""))
                Text("\(key)")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            HStack {
                Text("Value:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(value ?? "")")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            Divider()
        }
        .padding(.bottom, 8)
        .padding(.trailing, 6)
    }
    
    private func addParamItem() {
        items.append(Item(key: "", value: ""))
    }
}

struct ItemRow: View {
    @Binding var item: Item
    @State private var isEditing = false
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("Key:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(item.key)")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            if isEditing {
                HStack {
                    Text("Value:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    FocusedTextField("Enter value", text: $item.value, keepFirstResponder: .constant(false), onCommit: {
                        isEditing = false
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2) {
                        isEditing = true
                    }
                }
            } else {
                HStack {
                    Text("Value:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(item.value)")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                .contentShape(Rectangle())
                .onTapGesture(count: 2) {
                    isEditing = true
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
