//
//  scrap.swift
//  iosRequests
//
//  Created by Adel Al-Aali on 8/7/22.
//

import Foundation

//
//            print("[!] Starting Fetch on \n \(sessionURL) \n \t [!] [SESSION] \(session) \n \t [!] [SESSION-URL] \(sessionURL) \n [!] performing URL Grab on \(sessionURL.absoluteURL) ")
//
//        URLSession.shared.downloadTask(with: sessionURL).resume()
//        print("Performed URL Grab on \(sessionURL.absoluteURL)")



//    internal func setDLSession() throws {
//        let config = URLSessionConfiguration.default
//
//        var session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
//
//        var dataTask: URLSessionDataTask?
//
//
//        let dlUrl = urlParser.fetch.getUrl()
//        // guard let url = URL(string: urlParser.fetch.getUrl()) else { return }
//        let sessionURL = URL(string: dlUrl)
//
//        print(dlURL)
//
//
//        let downloadTask = URLSession.shared.downloadTask(with: sessionURL!) {
//            [weak self] data, response, error in
//
//            config.urlCredentialStorage = nil
//            //  let config = URLSessionConfiguration.default
//            config.httpAdditionalHeaders = ["User-Agent":"Legit Safari", "Authorization" : "Bearer key1234567"]
//            config.timeoutIntervalForRequest = 30
//            config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
//
//            print("[!] Starting Fetch on \n \(sessionURL) \n \t [!] [SESSION] \(session) \n \t [!] [SESSION-URL] \(sessionURL) \n [!] performing URL Grab on \(sessionURL?.absoluteURL) ")
//
//
//            do {
//                let documentsURL = try FileManager.default.url(for: .documentDirectory,
//                                                               in: .userDomainMask,
//                                                               appropriateFor: nil,
//                                                               create: false)
//
//                let savedURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
//                try FileManager.default.moveItem(at: fileURL, to: savedURL)
//            }
//            catch {
//                print ("[-] file error: \n \(error) \n [-] localized error \n \(LocalizedError.self)")
//            }
//            print("[+] Performed URL Grab on \n \(String(describing: sessionURL?.absoluteURL)) ")
//            print(downloadTask)
//
//
//            dataTask?.resume()
//
//
//
//
//        {
//            urlOrNil, responseOrNil, errorOrNil in
//
//            config.urlCredentialStorage = nil
//            //  let config = URLSessionConfiguration.default
//            config.httpAdditionalHeaders = ["User-Agent":"Legit Safari", "Authorization" : "Bearer key1234567"]
//            config.timeoutIntervalForRequest = 30
//            config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
//

//            guard let fileURL = urlOrNil else { return }
//
//            do {
//                let documentsURL = try FileManager.default.url(for: .documentDirectory,
//                                                               in: .userDomainMask,
//                                                               appropriateFor: nil,
//                                                               create: false)
//
//                let savedURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
//                try FileManager.default.moveItem(at: fileURL, to: savedURL)
//            }
//            catch {
//                print ("[-] file error: \n \(error) \n [-] localized error \n \(LocalizedError.self)")
//            }
//            print("[+] Performed URL Grab on \n \(String(describing: sessionURL?.absoluteURL)) ")
//            print(downloadTask)
//        }
//        downloadTask.resume()

//  FileLogic.work.createFolder()
// FileLogic.work.saveData(data: T##Data, name: <#T##String#>)
