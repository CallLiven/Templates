//
//  SideBarView.swift
//  Templates
//
//  Created by Liven on 2023/10/8.
//

import SwiftUI

class SidebarModel: ObservableObject {
    @Published var items: [String] = []
    @Published var isNameDuplicate = false
    
    func refreshItems() {
        items = FileHelper.shared.listFolders() ?? []
    }
    
    func addItem(named name: String) {
        items.append(name)
    }
    
    func addDefaultValue() {
        let defaultValueBase = "DefaultValue"
        var highestNumber = -1
        
        for item in items {
            if item.hasPrefix(defaultValueBase) {
                let numberPart = item.dropFirst(defaultValueBase.count)
                if let number = Int(numberPart), number > highestNumber {
                    highestNumber = number
                }
            }
        }
        
        let newDefaultValue = "\(defaultValueBase)\(highestNumber + 1)"
        items.append(newDefaultValue)
    }
    
    func checkDuplicateName(_ name: String) -> Bool {
        return items.contains(name)
    }
}


struct SideBarView: View {
    @ObservedObject private var model = SidebarModel()
    @State private var isEditingNewItem = false
    @State private var newItemName = ""
    @State private var showingDuplicateNameAlert = false
    @State private var shouldKeepFirstResponder = false
    
    init(model: SidebarModel = SidebarModel(), isEditingNewItem: Bool = false, newItemName: String = "") {
        self.model = model
        self.isEditingNewItem = isEditingNewItem
        self.newItemName = newItemName
        model.refreshItems()
    }
    
    var body: some View {
        VStack {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .foregroundColor(.blue)
                .frame(width: 20, height: 20)
                .hSpacing(.trailing)
                .padding(.trailing, 10)
                .onTapGesture {
                    isEditingNewItem = true
                    //model.addItem(named: "New Item")
                    model.addDefaultValue()
                }
            
            List {
                ForEach(model.items, id: \.self) { item in
                    NavigationLink(destination: TemplatesListView()) {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "folder.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.blue)
                                .frame(width: 20)
                            
                            if item == model.items.last, isEditingNewItem {
                                FocusedTextField("Enter item name",
                                                 text: $newItemName,
                                                 keepFirstResponder: $shouldKeepFirstResponder,
                                                 onCommit: {
                                    if !newItemName.isEmpty {
                                        if model.checkDuplicateName(newItemName) {
                                            showingDuplicateNameAlert = true
//                                            shouldKeepFirstResponder = true
                                        } else {
                                            model.items[model.items.count - 1] = newItemName
                                            let sandboxDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                            let newDirectoryURL = sandboxDirectory
                                                .appendingPathComponent("/templates")
                                                .appendingPathComponent(newItemName)
                                            do {
                                                try FileManager.default.createDirectory(at: newDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                                            } catch {
                                                print("Failed to create directory: \(error)")
                                            }
                                            isEditingNewItem = false
//                                            shouldKeepFirstResponder = false
                                        }
                                    }
                                    
                                })
                            } else {
                                Text(item)
                            }
                        }
                        .frame(height: 26)
                    }

                }
            }
            .listStyle(SidebarListStyle())
            .alert(isPresented: $showingDuplicateNameAlert) {
                Alert(title: Text("Duplicate Name"),
                      message: Text("The name \(newItemName) already exists."),
                      dismissButton: .default(Text("OK"),
                                              action: {
                    // 用户点击“OK”时执行的代码
                    
                }))
            }
        }.frame(minWidth: 200)
    }
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView()
    }
}
