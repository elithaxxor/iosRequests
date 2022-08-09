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





class downloaderLogic : NSObject, URLSessionDelegate {
	
	// MARK: Type alias for download closures
	typealias soupLinks = ([Element]?, String) -> Void
	typealias hrefLink =  (String?, String) -> Void
	typealias JSONDictionary = [String: Any]
	
	public let data = Data()
	static let shared = downloaderLogic()
	
	internal var dataTask: URLSessionDataTask?
	internal var sessionTask: URLSessionDownloadTask?
	internal var taskMetrics: URLSessionTaskMetrics?
	internal var defaultSession = URLSession(configuration: .default)
	internal var streamDelegate:  URLSessionStreamDelegate?
	internal var streamTask: URLSessionStreamTask?
	internal var sessionDownloadDelegate: URLSessionDownloadDelegate?
	
	internal var webSocketDelegate: URLSessionWebSocketDelegate?
	internal var webSocketTask: URLSessionWebSocketTask?
	
	
	fileprivate var errorMessage = ""
	fileprivate var hrefLinks: [Element] = []
	fileprivate var singleHref: String = ""
	
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
	

	func setDLSession(searchTerm: String, completion: @escaping hrefLink) throws {
		let dlUrl = urlParser.shared.getUrl()
		let group = DispatchGroup()
		dataTask?.cancel()
		
		print("[!] Starting Fetch on \(dlUrl)")
		group.enter()
		if var urlComponents = URLComponents(string: dlUrl) {
			guard let url = urlComponents.url else { return }
			let config = URLSessionConfiguration.ephemeral
			config.urlCredentialStorage = nil
			config.httpAdditionalHeaders = ["User-Agent":"Legit Safari", "Authorization" : "Bearer key1234567"]
			config.timeoutIntervalForRequest = 30
			config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
			// guard let sessionURL = URL(string: dlUrl)  else { return  } //?? URL(string: "https://httpbin.org/anything")
			var session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
			
			
			
			//self.updateHomeVCText(text: session.description)
			dataTask = session.dataTask(with: url) {  [weak self] data, response, error in
				defer { self?.dataTask = nil }
				let progress = self?.dataTask?.priority
				let taskResponse = self?.dataTask?.response
				let taskDescription = self?.dataTask?.taskDescription
				let sentBytes = self?.dataTask?.countOfBytesSent
				let recvBytes = self?.dataTask?.countOfBytesReceived
				let expectedRecvBytes = self?.dataTask?.countOfBytesExpectedToReceive
				let expectedSendBytes = self?.dataTask?.countOfBytesExpectedToSend
				
				
				if let error = error {
					self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
				} else if
					let data = data,
					let response = response as? HTTPURLResponse,
					response.statusCode == 200 {
					self?.updateSingleSearchResults(data)
					
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
			let progress = dataTask?.priority
			let taskResponse = dataTask?.response
			let taskDescription = dataTask?.taskDescription
			let sentBytes = dataTask?.countOfBytesSent
			let recvBytes = dataTask?.countOfBytesReceived
			let expectedRecvBytes = dataTask?.countOfBytesExpectedToReceive
			let expectedSendBytes = dataTask?.countOfBytesExpectedToSend
			
			let complete: String = " \n\n ******************* \n [+] Performed URL Grab on \n " // \(String(describing: dataTask.absoluteURL)) \n \n "
			self.completedText = complete.description
			print("[+] complete \n \(complete.description)")
			// print("[+] download task bytes recvd \(dataTask?.countOfBytesReceived)")
			self.updateHomeVCText(text: complete.description)
			DownloaderVC.shared.TEXT = complete.description
			dataTask?.resume()
			group.leave()
		}
		dataTask?.resume()
	}
	
	
	
	internal func setMultipleDLSession(completion: @escaping soupLinks) throws {
		let dlUrl = urlParser.shared.getUrl()
		let group = DispatchGroup()
		dataTask?.cancel()
		
		group.enter()
		print("[!] Starting Fetch on \(dlUrl)")
		if var urlComponents = URLComponents(string: dlUrl) {
			guard let url = urlComponents.url else { return }
			let config = URLSessionConfiguration.ephemeral
			config.urlCredentialStorage = nil
			config.httpAdditionalHeaders = ["User-Agent":"Legit Safari", "Authorization" : "Bearer key1234567"]
			config.timeoutIntervalForRequest = 30
			config.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
			
			var session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
			self.updateHomeVCText(text: session.description)
			
			dataTask = session.dataTask (with: url) { [weak self] data, response, error in
				defer { // allows scope of work when call exits
					self?.dataTask = nil
				}
				let progress = self?.dataTask?.priority
				let taskResponse = self?.dataTask?.response
				let taskDescription = self?.dataTask?.taskDescription
				let sentBytes = self?.dataTask?.countOfBytesSent
				let recvBytes = self?.dataTask?.countOfBytesReceived
				let expectedRecvBytes = self?.dataTask?.countOfBytesExpectedToReceive
				let expectedSendBytes = self?.dataTask?.countOfBytesExpectedToSend
				
				
				if let error = error {
					self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
				} else if
					let data = data,
					let response = response as? HTTPURLResponse,
					response.statusCode == 200 {
					self?.updateMultipleSearchResults(data)
					let status: String = "[!] Starting Fetch on [dlURL] \(String(describing: self?.dlURL)) \n \t [!] [SESSION] \(session) \n \t [!] [SESSION-URL] \(urlComponents) \n [!] performing URL Grab on \(session.description) "
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
			let complete: String = " \n\n ******************* \n [+] Performed URL Grab on \n " // \(String(describing: dataTask.absoluteURL)) \n \n "
			let progress = dataTask?.priority
			let taskResponse = dataTask?.response
			let taskDescription = dataTask?.taskDescription
			let sentBytes = dataTask?.countOfBytesSent
			let recvBytes = dataTask?.countOfBytesReceived
			let expectedRecvBytes = dataTask?.countOfBytesExpectedToReceive
			let expectedSendBytes = dataTask?.countOfBytesExpectedToSend
			self.completedText = complete.description
			print("[+] complete \n \(complete.description)")
			print("[+] download task bytes recvd \(dataTask?.countOfBytesReceived)")
			self.updateHomeVCText(text: complete.description)
			DownloaderVC.shared.TEXT = complete.description
			urlSession(session, downloadTask: sessionTask!, didFinishDownloadingTo: url)
			dataTask?.resume()
			group.leave()
		}
		dataTask?.resume()
		dataTask?.delegate = self
	}
	
	private func updateSingleSearchResults(_ data: Data) {
		var response: JSONDictionary?
		singleHref.removeAll()
		do {
			response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
		} catch let parseError as NSError {
			errorMessage += "[-] JSONSerialization error: \(parseError.localizedDescription )[-] \n"
			return
		}
		guard let array = response!["results"] as? [Any] else { errorMessage += "[!] Dictionary does not contain results key\n [!] "
			return
		}
		var index = 0
		for idx in array {
			if let idx = idx as? JSONDictionary,
			   let previewURLString = idx["previewUrl"] as? String,
			   let previewURL = URL(string: previewURLString),
			   let name = idx["download_1"] as? String {
				
				singleHref.append(downloadInfo(name: name, previewURL: previewURL, index: index))
				
				index += 1
			} else {
				errorMessage += "[-] Problem parsing  [-] \n"
			}
		}
	}
	private func updateMultipleSearchResults(_ data: Data) {
		
		var response: JSONDictionary?
		hrefLinks.removeAll()
		do {
			response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
		} catch let parseError as NSError {
			errorMessage += "[-] JSONSerialization error: \(parseError.localizedDescription )[-] \n"
			return
		}
		
		guard let array = response!["results"] as? [Any] else {
			errorMessage += "[!] Dictionary does not contain results key\n [!]"
			return
		}
		var index = 0
		for idx in array {
			if let idx = idx as? JSONDictionary,
			   let previewURLString = idx["previewUrl"] as? String,
			   let previewURL = URL(string: previewURLString),
			   let name = idx["download_1"] as? String {
				hrefLinks.append(downloadInfo(name: name, previewURL: previewURL, index: index))
				index += 1
			} else {
				errorMessage += "[-] Problem parsing  [-] \n"
			}
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
	
}


