//
//  FileHelper.swift
//  Templates
//
//  Created by Liven on 2023/10/8.
//

import Foundation

class FileUtils {
    
    static let shared = FileUtils()
    private init() {
        // 初始化时设置默认路径
        // Mac 文件访问权限官方文档：https://developer.apple.com/documentation/security/app_sandbox/accessing_files_from_the_macos_app_sandbox
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
    
    
    /// 指定路径下读取文件夹
    /// - Parameter path: path
    /// - Returns: [FolderName]
    func folders(atPath path: String? = nil) -> [String]? {
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
    
    
    /// 指定路径下所有的文件（包括文件夹），如果传后缀则只会筛选出后缀名一致的文件
    /// - Parameters:
    ///   - directoryPath: path
    ///   - fileExtension: 文件后缀
    /// - Returns: [FileName]
    func files(inDirectory directoryPath: String, withExtension fileExtension: String? = nil) -> [String]? {
        do {
            let directoryURL = URL(fileURLWithPath: directoryPath)
            let contents = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: [])
            
            let files: [URL]
            if let fileExtension = fileExtension {
                files = contents.filter { $0.pathExtension == fileExtension }
            } else {
                files = contents
            }
            
            return files.map { $0.lastPathComponent }
        } catch {
            print("Failed to list files in directory \(directoryPath): \(error)")
            return nil
        }
    }
    
    
    /// 判断指定路径下的文件是否存在
    /// - Parameter path: path
    /// - Returns: isExists
    func fileExists(atPath path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }
    
    
    /// 重命名或移动文件
    /// - Parameters:
    ///   - path: path
    ///   - newPath: path
    /// - Returns: 是否成功
    func renameFile(atPath path: String, to newPath: String) -> Bool {
        do {
            try fileManager.moveItem(atPath: path, toPath: newPath)
            return true
        } catch {
            print("Failed to rename file: \(error)")
            return false
        }
    }
    
    
    /// 读取文件的基本信息
    /// - Parameter path: path
    /// - Returns: FileAttributeKey
    func fileInfo(atPath path: String) -> [FileAttributeKey: Any]? {
        do {
            let attributes = try fileManager.attributesOfItem(atPath: path)
            return attributes
        } catch {
            print("Failed to get file info: \(error)")
            return nil
        }
    }
    
    
    /// 读取指定路径的文件内容
    /// - Parameter path: path
    /// - Returns: file content
    func readFileContent(atPath path: String) -> Data? {
        return fileManager.contents(atPath: path)
    }
    
    
    /// 创建文件并填充content
    /// - Parameters:
    ///   - path: path
    ///   - content: content
    /// - Returns: 是否成功
    func createFile(atPath path: String, content: Data? = nil) -> Bool {
        return fileManager.createFile(atPath: path, contents: content, attributes: nil)
    }
    
    /// <#Description#>
    /// - Parameter path: <#path description#>
    /// - Returns: <#description#>
    func deleteFile(atPath path: String) -> Bool {
        do {
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            print("Failed to delete file: \(error)")
            return false
        }
    }
    
    /// 重命名或移动文件
    /// - Parameters:
    ///   - path: path
    ///   - newPath: path
    /// - Returns: 是否成功
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

extension FileUtils {
    /// 读取moudle文件夹内的所有文件
    /// - Parameter moudle: moduleName
    /// - Returns: [fileName]
    func moudleContainFiles(_ moudle: String) -> [String]? {
        files(inDirectory: defaultPath + "templates/" + moudle)
    }
}
