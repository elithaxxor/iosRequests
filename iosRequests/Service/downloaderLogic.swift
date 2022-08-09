//
//  downloaderLogic.swift
//  DownloadManagerIII
//
//  Created by Adel Al-Aali on 6/19/22.
//

import Foundation
import UIKit
import SwiftSoup
import SafariServices



// MARK: To Download [single and multiple] files and storage locally
internal class singleDownloaderController {
    public var singleActiveDownloads :  [URL: singleDownload] = [ : ]
    var downloadsSession: URLSession!

}

internal class multipleDownloaderController {
    public var singleActiveDownloads :  [URL: singleDownload] = [ : ]
    var downloadsSession: URLSession!

}




internal class downloaderLogic: NSObject, URLSessionDelegate {
    
    //    private let dlVC = DownloaderVC()
    
    typealias JSONDictionary = [String: Any]
    typealias soupLinks = ([Elements]?, String) -> Void
    typealias hrefLink =  (String?, String) -> Void
    
    static let shared = downloaderLogic()
    internal var dataTask: URLSessionDataTask?
    internal var downloaderDelegate = URLSessionDownloadDelegate.self
    internal let defaultSession = URLSession(configuration: .default)
    
    fileprivate var errorMessage = ""
    fileprivate var hrefLinks: [Elements] = []
    fileprivate var singleHref: String? {
        didSet {
            print("[!] Single Href Set For Download! ")
            // setDLSession.(completion: ?, String) -> Void)
        }
    }
    
    
    // weak var access = downloaderLogic()
    
    public var dlURL: String = "" {
        didSet {
            print("[!] Downloader Logic URL set to \(dlURL.description)")
            //try?setDLSession()
        }
    }
    
    public var completedText: String = "" {
        didSet {
            print("completed text")
            DownloaderVC.shared.TEXT = completedText.lowercased()
            DownloaderVC.shared.viewWillLayoutSubviews()
        }
    }
    
    public func updateHomeVCText(text: String) {
        DispatchQueue.main.async {
            [weak self] in
            print("[!] Updating HomeVC [DOWNLOAD TEXT VIEW] --> \(text)")
            DownloaderVC.shared.textView?.text = text
            DownloaderVC.shared.viewWillAppear(true)
            
        }
    }
    //
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
    
    
    let data = Data()
    
    
    internal func setDLSession(completion: @escaping hrefLink) throws {
        
        let dlUrl = urlParser.shared.getUrl()
        let group = DispatchGroup()
        
        
        print("[!] Starting Fetch on \(dlUrl)")
        
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: dlUrl) {
            guard let url = urlComponents.url else { return }
            
            //        DispatchQueue.global(qos: .userInitiated).async {
            //            [weak self] in
            group.enter()
            let config = URLSessionConfiguration.ephemeral
            config.urlCredentialStorage = nil
            config.httpAdditionalHeaders = ["User-Agent":"Legit Safari", "Authorization" : "Bearer key1234567"]
            config.timeoutIntervalForRequest = 30
            config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
            // guard let sessionURL = URL(string: dlUrl)  else { return  } //?? URL(string: "https://httpbin.org/anything")
            var session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
            self.updateHomeVCText(text: session.description)
            
            dataTask = session.dataTask(with: url) {
                [weak self] data, response, error in
                
                defer { // allows scope of work when call exits
                    self?.dataTask = nil
                }
                
                if let error = error {
                    self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self?.updateSearchResults(data)
                    
                    var status: String = "[!] Starting Fetch on [dlURL] \(String(describing: self?.dlURL)) \n \t [!] [SESSION] \(session) \n \t [!] [SESSION-URL] \(urlComponents) \n [!] performing URL Grab on \(session.description) "
                    print(status)
                    
                    group.wait()
                    DispatchQueue.main.async {
                        [weak self] in
                        group.enter()
                        DownloaderVC.shared.textView?.text = status.description
                        self?.updateHomeVCText(text: status)
                        completion(self?.hrefLinks, self?.errorMessage ?? "")
                        group.leave()
                    }
                }
                group.enter()
                guard let fileURL = data else { return }
                do {
                    let documentsURL = try
                    FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let savedURL = documentsURL.appendingPathComponent(fileURL.description)
                    try FileManager.default.moveItem(at: savedURL, to: savedURL)
                    
                    
                    //try? self?.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: fileURL)
                } catch {
                    print ("file error: \(error)")
                }
            }
            dataTask?.resume()
            let complete: String = " \n\n ******************* \n [+] Performed URL Grab on \n " // \(String(describing: dataTask.absoluteURL)) \n \n "
            
            self.completedText = complete.description
            print("[+] complete \n \(complete.description)")
            // print("[+] download task bytes recvd \(dataTask?.countOfBytesReceived)")
            self.updateHomeVCText(text: complete.description)
            
            DownloaderVC.shared.TEXT = complete.description
            group.leave()
        }
    }
    
    
    internal func setMultipleDLSession(completion: @escaping soupLinks) throws {
        
        let dlUrl = urlParser.shared.getUrl()
        let group = DispatchGroup()
        
        
        print("[!] Starting Fetch on \(dlUrl)")
        
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: dlUrl) {
            guard let url = urlComponents.url else { return }
            
            group.enter()
            let config = URLSessionConfiguration.ephemeral
            config.urlCredentialStorage = nil
            config.httpAdditionalHeaders = ["User-Agent":"Legit Safari", "Authorization" : "Bearer key1234567"]
            config.timeoutIntervalForRequest = 30
            config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
            // guard let sessionURL = URL(string: dlUrl)  else { return  } //?? URL(string: "https://httpbin.org/anything")
            var session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
            self.updateHomeVCText(text: session.description)
            
            dataTask = session.dataTask (with: url) { [weak self] data, response, error in
                defer { // allows scope of work when call exits
                    self?.dataTask = nil
                }
                
                if let error = error {
                    self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self?.updateSearchResults(data)
                    
                    var status: String = "[!] Starting Fetch on [dlURL] \(String(describing: self?.dlURL)) \n \t [!] [SESSION] \(session) \n \t [!] [SESSION-URL] \(urlComponents) \n [!] performing URL Grab on \(session.description) "
                    print(status)
                    
                    group.wait()
                    DispatchQueue.main.async {
                        [weak self] in
                        group.enter()
                        DownloaderVC.shared.textView?.text = status.description
                        self?.updateHomeVCText(text: status)
                        completion(self?.hrefLinks, self?.errorMessage ?? "")
                        group.leave()
                    }
                }
                group.enter()
                guard let fileURL = data else { return }
                do {
                    let documentsURL = try
                    FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let savedURL = documentsURL.appendingPathComponent(fileURL.description)
                    try FileManager.default.moveItem(at: savedURL, to: savedURL)
                    
                    
                    //try? self?.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: fileURL)
                } catch {
                    print ("file error: \(error)")
                }
                
            }
            
            dataTask?.resume()
            let complete: String = " \n\n ******************* \n [+] Performed URL Grab on \n " // \(String(describing: dataTask.absoluteURL)) \n \n "
            self.completedText = complete.description
            print("[+] complete \n \(complete.description)")
            print("[+] download task bytes recvd \(dataTask?.countOfBytesReceived)")
            self.updateHomeVCText(text: complete.description)
            
            DownloaderVC.shared.TEXT = complete.description
            group.leave()
        }
        dataTask?.resume()

    }
    private func updateSearchResults(_ data: Data) {
    }
}

extension downloaderLogic: URLSessionDownloadDelegate {
    
    // TODO: Save data to local storage.
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
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
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = bytesWritten / totalBytesExpectedToWrite
        DownloaderVC.shared.progressBar?.progress = Float(progress)
        DownloaderVC.shared.progressLbl.text = "\(progress * 100)%"
        print("[!] Download Progress \(progress * 100)%")
    }
}


