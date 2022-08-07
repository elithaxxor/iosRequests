//
//  FileLogic.swift
//  DownloadManagerIII
//
//  Created by Adel Al-Aali on 6/19/22.
//

import Foundation
import UIKit



internal class FileLogic {
    static var work = FileLogic()
    fileprivate static let ImageName : String? = "test_image00"
    fileprivate(set) var imageName : String? = nil
    @Published var image: UIImage? = nil
   // static let instance = FileManagerLogic()
    
    internal func saveData(data: Data, name: String)  {
        // guard let data = image.jpegData(compressionQuality: 1.0) else { return }

        guard let mainDir = try? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        guard let downloadDir = try? FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else { return }
        guard let cachedDir = try? FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        let path = (try? getImgPath(name: "\(name).jpg")) ?? cachedDir

        do {
            try data.write(to: path)
            print("[+] Successful- Saved to CachePath ")

        } catch let error {
            print("[-] Error in writting to cachePath \(error)")
        }
        print("[!] Fetching Data on \(data.description) ")
        print("[!] Main Dir [\(mainDir.description)] \(mainDir) ")
        print("[!] Cached Dir [\(downloadDir.description)] \(downloadDir)")
        print("[!] Cached Dir [\(cachedDir.description)] \(cachedDir)")
    }


    // MARK: Returns imge path,
    internal func getImgPath(name: String) throws -> URL? {
        print("[!] Getting Image Path for: \(name).jpg")
        guard
            let cachePath = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(name).jpg") else {
            throw LocalFileErr.cachedDirErr
        }
        return cachePath
    }

    //MARK: Returns Binary data of img from parsed path, returns UIIMAGE
    internal func getImg(name: String) throws -> UIImage? {
        print("[!] Getting Image from Path for: \(name).jpg")
        guard let path = try? getImgPath(name: name)?.path else { throw LocalFileErr.getImgErr }
        return UIImage(contentsOfFile: path)
    }
    
    internal func deleteImg(name: String) throws {
        print("[!] Deleting Image from Path: \(name).jpg")
        guard let path = try getImgPath(name: name) else { throw LocalFileErr.deleteImgErr }
        guard let pathStr = try getImgPath(name: name)?.path else { throw LocalFileErr.deleteImgErr }
        if (FileManager.default.fileExists(atPath: pathStr) == true) {
            do {
                try FileManager.default.removeItem(at: path)
                print("[+] Successfully Deleted Item @\(path)")

            } catch let error {
                print("[-] Error in deleting image \(error)")
            }
        }
    }

    internal func createFolder() {
        guard let path = FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("newFolder")
            .path else {
            return
        }
        if !FileManager.default.fileExists(atPath: path)
        {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                print("[+] Sucessfully created new folder")
            } catch let error {
                print("[-] Error in creating folder \(error)")
            }
        }
    }
}

enum LocalFileErr : Error {
    case MainDirirectoryerr
    case tempDirErr
    case cachedDirErr
    case pathError
    case getImgErr
    case deleteImgErr
}

extension LocalFileErr {
    public var LocalFileDescr : String {
        switch self {
            case .MainDirirectoryerr : return "[!] Theres an issue in the [MAIN] directory path. "
            case .tempDirErr : return "[!] Theres an issue in the [TEMP] directory path. "
            case .cachedDirErr : return "[!] Theres an issue in the [CACHE] directory path. "
            case .pathError : return "[!] Theres an issue in the [PATH]. Cannot fetch data . "
            case .getImgErr : return "[!] Theres an issue in the [getImgDir]. Cannot fetch data . "
            case .deleteImgErr : return "[!] Theres an issue in the [deleting image]. Cannot delete data ."
        }
    }
}
