//
//  TemplatesListView.swift
//  Templates
//
//  Created by Liven on 2023/10/9.
//

import SwiftUI

struct TemplatesListView: View {
    @EnvironmentObject var appState: AppState
    @State private var fileName: String = ""
    @State private var filePath: String = ""
    @State private var fileContent: String = ""

    var body: some View {
        VStack {
            TemplatesListHeaderView()
            Button("Open File") {
                let openPanel = NSOpenPanel()
                openPanel.allowsMultipleSelection = false
                openPanel.canChooseDirectories = false
                openPanel.canCreateDirectories = false
                openPanel.canChooseFiles = true
                if openPanel.runModal() == .OK {
                    if let url = openPanel.url {
                        readFile(url: url)
                    }
                }
            }
            
            Button("Save New File") {
                saveNewFile()
            }
            
            
            List {
                NavigationLink(destination: DetailView()) {
                    TemplatesListCellView(fileContent: $fileContent)
                }
                NavigationLink(destination: DetailView()) {
                    TemplatesListCellView(fileContent: $fileContent)
                }
                // ... add more items
            }
            .frame(minWidth: 300)
        }
    }
    
    func readFile(url: URL) {
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            self.fileName = url.lastPathComponent
            self.filePath = url.path
            self.fileContent = content
        } catch {
            print("Error reading file: \(error.localizedDescription)")
        }
    }
    
//    func saveNewFile() {
//        let newContent = fileContent.replacingOccurrences(of: "{#name}", with: "Liven")
//        let newFileName = "new_" + fileName
//        let desktopPath = FileManager.default.homeDirectoryForCurrentUser
//            .appendingPathComponent("Desktop/TempDemo/")
//            .appendingPathComponent(newFileName)
//
//        do {
//            try FileManager.default.createDirectory(
//                at: desktopPath.deletingLastPathComponent(),
//                withIntermediateDirectories: true,
//                attributes: nil
//            )
//            try newContent.write(to: desktopPath, atomically: true, encoding: .utf8)
//            print("File saved at: \(desktopPath)")
//        } catch {
//            print("Error saving file: \(error.localizedDescription)")
//        }
//    }
    
    func saveNewFile() {
//        encodeSafetyTay()
        if let bookmarkData = UserDefaults.standard.data(forKey: "TempDemoBookmark") {
            accessTempDemoFolder()
        } else {
            // 创建安全标签，为了可以获取到文件夹的读写权限
            let openPanel = NSOpenPanel()
            openPanel.canChooseFiles = false
            openPanel.canChooseDirectories = true
            openPanel.allowsMultipleSelection = false
            openPanel.prompt = "Grant Access"
            openPanel.message = "Please select the TempDemo folder on your desktop."
            openPanel.directoryURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop/TempDemo")
            
            openPanel.begin { response in
                if response == .OK, let url = openPanel.url {
                    self.createBookmark(for: url)
                }
            }
        }
    }
    
    
    /// 解析已保存的安全标签，直接保存文件
    func accessTempDemoFolder() {
        if let bookmarkData = UserDefaults.standard.data(forKey: "TempDemoBookmark") {
            var isStale = false
            do {
                let bookmarkURL = try URL(resolvingBookmarkData: bookmarkData,
                                          options: .withSecurityScope,
                                          relativeTo: nil,
                                          bookmarkDataIsStale: &isStale)
                if isStale {
                    // The bookmark data is stale and needs to be recreated.
                    print("Bookmark data is stale")
                } else if bookmarkURL.startAccessingSecurityScopedResource() {
                    // Access the folder using bookmarkURL
                    var directoryPath = bookmarkURL
                    // Perform your file operations here...
                    let newContent = fileContent.replacingOccurrences(of: "{#name}", with: "Liven")
                    let newFileName = "new_" + fileName
                    directoryPath = directoryPath
                        .appendingPathComponent("templates/")
                        .appendingPathComponent(newFileName)
                    
                    do {
                        try FileManager.default.createDirectory(
                            at: directoryPath.deletingLastPathComponent(),
                            withIntermediateDirectories: true,
                            attributes: nil
                        )
                        try newContent.write(to: directoryPath, atomically: true, encoding: .utf8)
                        print("File saved at: \(directoryPath)")
                    } catch {
                        print("Error saving file: \(error.localizedDescription)")
                    }
                    
                    // Don't forget to stop accessing the resource when done.
                    bookmarkURL.stopAccessingSecurityScopedResource()
                }
            } catch {
                print("Error resolving bookmark: \(error)")
            }
        }
    }
    
    
    /// 保存安全标签
    func createBookmark(for url: URL) {
        do {
            let bookmarkData = try url.bookmarkData(options: .withSecurityScope,
                                                    includingResourceValuesForKeys: nil,
                                                    relativeTo: nil)
            UserDefaults.standard.set(bookmarkData, forKey: "TempDemoBookmark")
        } catch {
            print("Error creating bookmark: \(error)")
        }
    }
}

struct TemplatesListView_Previews: PreviewProvider {
    static var previews: some View {
        TemplatesListView()
    }
}

