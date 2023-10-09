//
//  FileHelper.swift
//  Templates
//
//  Created by Liven on 2023/10/8.
//

import Foundation

class FileHelper {
    
    static let shared = FileHelper()
    private init() {
        // 初始化时设置默认路径
        let sandboxDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        defaultPath = sandboxDirectory.appendingPathComponent("templates").path
        
        // 确保Templates文件夹存在
        if !fileManager.fileExists(atPath: defaultPath) {
            do {
                try fileManager.createDirectory(atPath: defaultPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create Templates directory: \(error)")
            }
        }
    }
    
    let fileManager = FileManager.default
    var defaultPath: String
    
    func listFolders(atPath path: String? = nil) -> [String]? {
        let fullPath = path ?? defaultPath
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: fullPath)
            let folders = contents.compactMap { item -> String? in
                let itemPath = (fullPath as NSString).appendingPathComponent(item)
                var isDirectory: ObjCBool = false
                if fileManager.fileExists(atPath: itemPath, isDirectory: &isDirectory), isDirectory.boolValue {
                    return item
                }
                return nil
            }
            return folders
        } catch {
            print("Failed to list all folders: \(error)")
            return nil
        }
    }
    
    func fileExists(atPath path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }
    
    func renameFile(atPath path: String, to newPath: String) -> Bool {
        do {
            try fileManager.moveItem(atPath: path, toPath: newPath)
            return true
        } catch {
            print("Failed to rename file: \(error)")
            return false
        }
    }
    
    func fileInfo(atPath path: String) -> [FileAttributeKey: Any]? {
        do {
            let attributes = try fileManager.attributesOfItem(atPath: path)
            return attributes
        } catch {
            print("Failed to get file info: \(error)")
            return nil
        }
    }
    
    func readFileContent(atPath path: String) -> Data? {
        return fileManager.contents(atPath: path)
    }
    
    func createFile(atPath path: String, content: Data? = nil) -> Bool {
        return fileManager.createFile(atPath: path, contents: content, attributes: nil)
    }
    
    func deleteFile(atPath path: String) -> Bool {
        do {
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            print("Failed to delete file: \(error)")
            return false
        }
    }
    
    func moveFile(fromPath path: String, toPath newPath: String) -> Bool {
        do {
            try fileManager.moveItem(atPath: path, toPath: newPath)
            return true
        } catch {
            print("Failed to move file: \(error)")
            return false
        }
    }
}
