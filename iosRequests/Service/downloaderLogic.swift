//
//  downloaderLogic.swift
//  DownloadManagerIII
//
//  Created by Adel Al-Aali on 6/19/22.
//

import Foundation
import UIKit
import SwiftSoup


class downloaderLogic: NSObject {
    fileprivate(set) var url: String = "" {
        didSet {
            try?setSession()
        }
    }
    
    internal func setSession() throws {
        print("[!] Starting Fetch on \(url)")
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["User-Agent":"Legit Safari", "Authorization" : "Bearer key1234567"]
        config.timeoutIntervalForRequest = 30
        config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
        guard let sessionURL = URL(string: url) ?? URL(string: "https://httpbin.org/anything") else { return  }
        
        var session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
        URLSession.shared.downloadTask(with: sessionURL).resume()
    }
}
extension downloaderLogic: URLSessionDownloadDelegate {
    
    // TODO: Save data to local storage.
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("[!] Starting URL Session")
        guard let data = try? Data(contentsOf: location) else {
            print("[-] Data Could Not Be Parsed. ")
            return
        }
        print(data)
        DispatchQueue.main.async { [weak self] in
            FileLogic.work.saveData(data: data, name: location.description)
            DownloaderVC.down.progressLbl.isHidden = true
        }
        
    }
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = bytesWritten / totalBytesExpectedToWrite
        DownloaderVC.down.progressBar?.progress = Float(progress)
        DownloaderVC.down.progressLbl.text = "\(progress * 100)%"
        print("[!] Download Progress \(progress * 100)%")
    }
}

enum sessionsError : Error {
    case urlErr
    case noDataInResponse
    case noJsonResponse
}
extension sessionsError  {
    private var downloaderLogiErr : String {
        switch self {
        case .urlErr : return "[-] Error URL Session Closure"
        case .noDataInResponse : return "[-] No Data in Sessions Response"
        case .noJsonResponse : return "[-] No Json in Sessions Response"
        }
    }
    
}

