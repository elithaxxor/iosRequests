//
//  downloaderLogic.swift
//  DownloadManagerIII
//
//  Created by Adel Al-Aali on 6/19/22.
//

import Foundation
import UIKit
import SwiftSoup


internal class downloaderLogic: NSObject, URLSessionDelegate {
    
    // private let dlVC = DownloaderVC()
    private static let shared = downloaderLogic()
    public var dlURL: String = "" {
        didSet {
            print("[!] Downloader Logic URL set to \(dlURL.description)")
            
            //try?setDLSession()
        }
    }
    
    private lazy var urlSession = URLSession(configuration: .default,
                                             delegate: self,
                                             delegateQueue: nil)
    
    public func updateHomeVCText(text: String) {
        DispatchQueue.main.async {
            [weak self] in
            print("[!] Updating HomeVC [DOWNLOAD TEXT VIEW] --> \(text)")
            DownloaderVC.shared.textView?.text = text
            DownloaderVC.shared.viewWillAppear(true)
        }
        
    }
        
    internal func setFTPSession() throws {
        let config = URLSessionConfiguration.ephemeral
        config.urlCredentialStorage = nil
        config.httpAdditionalHeaders = ["User-Agent":"Legit Safari", "Authorization" : "Bearer key1234567"]
        config.timeoutIntervalForRequest = 30
        config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
        guard let sessionURL = URL(string: dlURL) ?? URL(string: "https://httpbin.org/anything") else { return  }
        var session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
        URLSession.shared.downloadTask(with: sessionURL).resume()
        print("Performed URL Grab on \(sessionURL.absoluteURL)")
    }
    
   
    
    internal func setDLSession() throws {
        let dlUrl = urlParser.fetch.getUrl()
        
        print("[!] Starting Fetch on \(dlUrl)")
        updateHomeVCText(text: dlUrl)

        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = ["User-Agent":"Legit Safari", "Authorization" : "Bearer key1234567"]
            config.timeoutIntervalForRequest = 30
            config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
            guard let sessionURL = URL(string: dlUrl)  else { return  } //?? URL(string: "https://httpbin.org/anything")
            
            var session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
            self?.updateHomeVCText(text: session.description)
            var downloadTask = URLSession.shared.downloadTask(with: sessionURL) {
                [weak self] data, response, error in
                
                var status: String = "[!] Starting Fetch on [dlURL] \(self?.dlURL) \n \t [!] [SESSION] \(session) \n \t [!] [SESSION-URL] \(sessionURL) \n [!] performing URL Grab on \(sessionURL.absoluteURL) "
                print(status)
                
                DispatchQueue.main.async {
                    DownloaderVC.shared.textView?.text = status
                }
                
                
                guard let fileURL = data else { return }
                do {
                    let documentsURL = try
                    FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let savedURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
                    try FileManager.default.moveItem(at: fileURL, to: savedURL)
                } catch {
                    print ("file error: \(error)")
                    
                }
            }
            
            downloadTask.resume()
            let complete: String = "[+] Performed URL Grab on \n \(String(describing: sessionURL.absoluteURL)) "
            print("[+] Performed URL Grab on \n \(String(describing: sessionURL.absoluteURL)) ")
            print(downloadTask)
            self?.updateHomeVCText(text: complete)
        }
    }
}

extension downloaderLogic: URLSessionDownloadDelegate {
    
    // TODO: Save data to local storage.
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("[!] Starting URL Delegate Session")
        guard let data = try? Data(contentsOf: location) else {
            print("[-] Data Could Not Be Parsed. ")
            return
        }
        print("******************************************** \n [DATA] \n \n ")
        print(data)
        print("******************************************** \n [DATA] \n \n ")
        DispatchQueue.main.async { [weak self] in
            FileLogic.work.createFolder()
            FileLogic.work.saveData(data: data, name: location.description)
            DownloaderVC.shared.progressLbl.isHidden = true
        }
        
    }
    internal func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = bytesWritten / totalBytesExpectedToWrite
        DownloaderVC.shared.progressBar?.progress = Float(progress)
        DownloaderVC.shared.progressLbl.text = "\(progress * 100)%"
        print("[!] Download Progress \(progress * 100)%")
    }
}


